extends Node

signal user_updated
signal progression_cleared
signal signed_up
signal log_in_response
signal player_progress_fetched
signal level_scores_fetched


var player_progress
var num_of_levels=count_levels()
var level_scores={}
var username
var score = []
var popup=preload("res://Scenes/Screens/popup_messenger.tscn")



var logged_in_username="tqd"
var http_request : HTTPRequest = HTTPRequest.new()
const SERVER_URL = "http://spaghetticodestudios.com/db_test.php"
const SERVER_HEADERS = ["Content-Type: application/x-www-form-urlencoded", "Cache-Control: max-age=0"]
var SECRET_KEY="1234567890"
var nonce = null
var request_queue : Array = []
var is_requesting : bool = false
#db stads^^

func _ready():
	randomize()
	add_child(http_request)
	http_request.request_completed.connect(_http_request_completed)
	

func _process(delta):

	if is_requesting:

		return
		

	if request_queue.is_empty():
		return
		
	is_requesting = true
	if nonce==null:
		#pass
		request_nonce()
	else:
		
		_send_request(request_queue.pop_front())

func _http_request_completed(_result, _response_code, _headers, _body):
	is_requesting = false
	if _result != http_request.RESULT_SUCCESS:
		printerr("Error w/ connection: " + String(_result))
		return
	
	var response_body = _body.get_string_from_utf8()
	var json = JSON.new()
	print(response_body)
	var error = json.parse(response_body)
	var response=json.get_data()
	
	print("***********")
	print(response)
	print("***********")
	if error:
		printerr("We returned error: " + str(error))
		return
	
	if response["command"]=="get_nonce":
		nonce = response["response"]["nonce"]
		print("Got nonce"+response["response"]["nonce"])
		return
	
	
	if response["command"]=="get_player_progress":
		player_progress=response["datasize"]
		emit_signal("player_progress_fetched")
	if response["command"]=="add_user":
		emit_signal("signed_up")

	if response["command"]=="get_player_username":
		emit_signal("log_in_response",response["response"])
	
	
	if response["command"]=="get_level_scores":
		
		json=JSON.new()
		print("HERE")
		error=json.parse(response["response"])
		var transform=json.get_data()
		print(transform)
		print("HERE")
		var this_level=str(transform["0"]["level"])
		print(this_level)
		level_scores[str(this_level)]=[]
		for n in response["datasize"]:
			level_scores[str(this_level)].append(transform[str(n)])
		print(len(level_scores))
		print(num_of_levels)
		print("********")
		if (len(level_scores)<num_of_levels):
			print("recall")
			get_level_scores(len(level_scores)+1)
			return
		
		emit_signal("level_scores_fetched")
		
		
		
	if response['datasize'] > 1:
		print("**")
		print(response["response"])
		#for n in response['datasize']:
			#print(str(response['response'][str(n+1)]['player_name']) + "\t\t" + str(response['response'][str(n+1)]['score']) + "\n")
	elif response['datasize'] == 1:
		
		
		var response_2 = str(response['response'])
		response_2 = response_2.replace("{","{\"")
		response_2 = response_2.replace(":","\":\"")
		response_2 = response_2.replace(", ","\", \"")
		response_2 = response_2.replace("}","\"}")
		print(response_2)

		#print(str(response_2['player_name']) + "has score" + str(response_2['score']))
	else:
		print("No data")
	

func request_nonce():
	print("nonce getting")
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data" : JSON.stringify({})})
	var body =  "command=get_nonce&"+data
	
	var err = http_request.request(SERVER_URL, SERVER_HEADERS, HTTPClient.METHOD_POST, body)
	
	if err != OK:
		printerr("HTTPRequest error: " + String(err))
		return
	
	print("Requeste nonce")

func _send_request(request: Dictionary):
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data" : JSON.stringify(request['data'])})
	var body = "command=" + request['command'] + "&" + data
	
	var cnonce = str(Crypto.new().generate_random_bytes(32)).sha256_text()
	print(nonce)
	print(cnonce)
	print(body)
	print(SECRET_KEY)
	
	var client_hash = str(nonce + cnonce + body + SECRET_KEY).sha256_text()
	nonce = null
	
	var headers = SERVER_HEADERS.duplicate()
	headers.push_back("cnonce: " + cnonce)
	headers.push_back("hash: " + client_hash)
	
	
	
	var err = http_request.request(SERVER_URL, SERVER_HEADERS, HTTPClient.METHOD_POST, body)
	
	if err != OK:
		printerr("HTTPRequest error: " + String(err))
		
		
	#print(body)
	print("Requesting...\n\tCommand: " + request['command'] + "\n\tBody: " + body)
	
	
func submit_score(user_name,level,score):
	var command = "add_score"
	var data = {"username" : user_name, "score" : score,"level":level}
	request_queue.push_back({"command" : command, "data" : data})
	
func _get_scores():
	var command = "get_scores"
	var data = {"score_ofset" : 0, "score_number" : 10}
	request_queue.push_back({"command" : command, "data" : data})

func _get_player():
	var command = "get_player"
	var user_id = $ID.get_text()
	var data = {"user_id" : user_id}
	request_queue.push_back({"command" : command, "data" : data})

func test_db(user_id):
	var command = "get_player"
	var data = {"user_id" : user_id}
	request_queue.push_back({"command" : command, "data" : data})

func register_new_user(username,password):
	var command = "add_user"
	var data = {"username" : username,"password":password}
	request_queue.push_back({"command" : command, "data" : data})

func login_user(username,password):
	var command ="get_player_username"
	var data = {"username" : username,"password":password}
	request_queue.push_back({"command" : command, "data" : data})


func get_level_scores(level):
	var command = "get_level_scores"
	var data = { "score_number" : 5,"level":level}
	request_queue.push_back({"command" : command, "data" : data})


func get_player_progress(username):
	var command = "get_player_progress"
	var data = { "username" : username}
	request_queue.push_back({"command" : command, "data" : data})
	

func count_levels():
	var dir = DirAccess.open("res://Scenes/Levels/")
	var counter=0
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			counter+=1
			file_name = dir.get_next()
	return (counter-1)

func popup_message(message,parentNode):
	var popup_instance=popup.instantiate()
	popup_instance.get_child(0).set_text(message)
	parentNode.add_child(popup_instance)
