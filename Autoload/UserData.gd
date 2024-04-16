extends Node

signal user_updated
signal progression_cleared

var tile_posiiton
var username
var score = []


var http_request : HTTPRequest = HTTPRequest.new()
const SERVER_URL = "http://spaghetticodestudios.com/db_test.php"
const SERVER_HEADERS = ["Content-Type: application/x-www-form-urlencoded", "Cache-Control: max-age=0"]
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
	_send_request(request_queue.pop_front())
	
	
			
	
func _http_request_completed(_result, _response_code, _headers, _body):
	is_requesting = false
	if _result != http_request.RESULT_SUCCESS:
		printerr("Error w/ connection: " + String(_result))
		return
	
	var response_body = _body.get_string_from_utf8()
	var json = JSON.new()
	#print(response_body)
	var error = json.parse(response_body)
	var response=json.get_data()
	print("*********")
	print(response)
	if error:
		printerr("We returned error: " + str(error))
		return
	

	if response['datasize'] > 1:
		print("")
		for n in response['datasize']:
			print($TextEdit.get_text() + str(response['response'][str(n)]['player_name']) + "\t\t" + str(response['response'][str(n)]['score']) + "\n")
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
	


func _send_request(request: Dictionary):
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data" : JSON.stringify(request['data'])})
	var body = "command=" + request['command'] + "&" + data
	
	var err = http_request.request(SERVER_URL, SERVER_HEADERS, HTTPClient.METHOD_POST, body)
	
	if err != OK:
		printerr("HTTPRequest error: " + String(err))
		return
		
	#print(body)
	print("Requesting...\n\tCommand: " + request['command'] + "\n\tBody: " + body)
	
	
func submit_score(user_name,score):
	var command = "add_score"
	var data = {"username" : user_name, "score" : score}
	request_queue.push_back({"command" : command, "data" : data})
	
func _get_scores():
	var command = "get_scores"
	var data = {"score_ofset" : 0, "score_number" : 10}
	request_queue.push_back({"command" : command, "data" : data})
	print("get scores")

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

