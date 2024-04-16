extends Control


# Declare member variables here. Examples:
var http_request : HTTPRequest = HTTPRequest.new()
const SERVER_URL = "http://spaghetticodestudios.com/db_test.php"
const SERVER_HEADERS = ["Content-Type: application/x-www-form-urlencoded", "Cache-Control: max-age=0"]
var request_queue : Array = []
var is_requesting : bool = false



# Called when the node enters the scene tree for the first time.
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
	$TextEdit.set_text(response_body)
	var error = json.parse(response_body)
	var response=json.get_data()
	if error:
		printerr("We returned error: " + str(error))
		return
	

	if response['datasize'] > 1:
		$TextEdit.set_text("")
		for n in response['datasize']:
			$TextEdit.set_text($TextEdit.get_text() + str(response['response'][str(n)]['player_name']) + "\t\t" + str(response['response'][str(n)]['score']) + "\n")
	elif response['datasize'] == 1:
		var response_2 = str(response['response'])
		response_2 = response_2.replace("{","{\"")
		response_2 = response_2.replace(":","\":\"")
		response_2 = response_2.replace(", ","\", \"")
		response_2 = response_2.replace("}","\"}")
		$TextEdit.set_text(response_2)
		#$TextEdit.set_text(str(response_2['player_name']) + "has score" + str(response_2['score']))
	else:	
		$TextEdit.set_text("No data")
	
	
func _send_request(request: Dictionary):
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data" : JSON.stringify(request['data'])})
	var body = "command=" + request['command'] + "&" + data
	
	var err = http_request.request(SERVER_URL, SERVER_HEADERS, HTTPClient.METHOD_POST, body)
	
	if err != OK:
		printerr("HTTPRequest error: " + String(err))
		return
		
	#$TextEdit.set_text(body)
	print("Requesting...\n\tCommand: " + request['command'] + "\n\tBody: " + body)
	
	

	
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





func _on_add_score_pressed():
	UserData.submit_score($PlayerName.get_text(),$Score.get_text())
