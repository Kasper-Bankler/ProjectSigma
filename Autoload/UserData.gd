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



var logged_in_username="coolaani"
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
	
	#forbinder request kald til det korrosponderende funktion
	http_request.request_completed.connect(_http_request_completed)
	

func _process(_delta):
	
	#Kun en requets ad gangen
	if is_requesting:
		return
		
	#Hvis der ikke er nogen requests så ik gør noget
	if request_queue.is_empty():
		return
		
	
	is_requesting = true
	
	#opretter nonce hvis ikke allerede har en
	if nonce==null:
		request_nonce()
	else:
		_send_request(request_queue.pop_front())


func _http_request_completed(_result, _response_code, _headers, _body):
	
	#færdig med request
	is_requesting = false
	
	#tjekker for forbindelsesfejl
	if _result != http_request.RESULT_SUCCESS:
		printerr("Error w/ connection: " + String(_result))
		return
	
	#konverterer til string
	var response_body = _body.get_string_from_utf8()

	
	#forsøger at konvertere fra string til json, error hvis det ikke lykkes
	var json = JSON.new()
	var error = json.parse(response_body)
	var response=json.get_data()

	#Fej håndtering af en kontrolleret error der signalerer, at der har været forsøg på indsættelse af en bruger med allerede eksisterende brugernavn. 
	if response["command"]=="add_user" and response["error"]=="sameusername":
			emit_signal("signed_up",true)
			return
	
	#Ukendt error håndteres ved at printe ud for debug
	if error:
		printerr("We returned error: " + str(error))
		return
	
	#Hvis request var efter nonce, sætter nonce til resultatet
	if response["command"]=="get_nonce":
		nonce = response["response"]["nonce"]
		return
	
	#Hvis request var efter rækker af brugerens niveau i spillet, sætter den hensigtede variabel/sender signal
	if response["command"]=="get_player_progress":
		player_progress=response["datasize"]
		emit_signal("player_progress_fetched")
	
	#Hvis request var tilføjelse af bruger, sætter den hensigtede variabel/sender signal. (false betegner at der ikke var nogen fejl)
	if response["command"]=="add_user":
		emit_signal("signed_up",false)

	#Hvis request var efter brugerdata med specifikt brugernavn, sender signal
	if response["command"]=="get_player_username":
		emit_signal("log_in_response",response["response"])
	
	#Hvis request var efter data til leaderboard, sætter den hensigtede variabel/sender signal
	if response["command"]=="get_level_scores":
		
		#Hvis der ikke var noget data er det fordi den har hentet points data til alle levels og signalerer dette 
		if (response["datasize"]==0):
			emit_signal("level_scores_fetched")
			return
			
		#konverterer til json fra string
		json=JSON.new()
		error=json.parse(response["response"])
		var transform=json.get_data()
		
		#konverterer til array fra objekt
		var this_level=str(transform["0"]["level"])
		level_scores[str(this_level)]=[]
		
		for n in response["datasize"]:
			level_scores[str(this_level)].append(transform[str(n)])
		
		#Henter data for den næste level
		if (len(level_scores)<num_of_levels):
			get_level_scores(len(level_scores)+1)
			return
		
		emit_signal("level_scores_fetched")
		
	



func _send_request(request: Dictionary):
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data" : JSON.stringify(request['data'])})
	var body = "command=" + request['command'] + "&" + data
	
	var cnonce = str(Crypto.new().generate_random_bytes(32)).sha256_text()
	
	
	var client_hash = str(nonce + cnonce + body + SECRET_KEY).sha256_text()
	nonce = null
	
	var headers = SERVER_HEADERS.duplicate()
	headers.push_back("cnonce: " + cnonce)
	headers.push_back("hash: " + client_hash)
	
	
	
	var err = http_request.request(SERVER_URL, headers, HTTPClient.METHOD_POST, body)
	
	if err != OK:
		printerr("HTTPRequest error: " + String(err))
		
	
	
	
func request_nonce():
	
	#samme boilerplate kode som under request, men her er de ingen ekstra headers
	var client = HTTPClient.new()
	var data = client.query_string_from_dict({"data" : JSON.stringify({})})
	var body =  "command=get_nonce&"+data
	
	var err = http_request.request(SERVER_URL, SERVER_HEADERS, HTTPClient.METHOD_POST, body)
	
	if err != OK:
		printerr("HTTPRequest error: " + String(err))
		return


#funktioner til request med hver af de php kommandoer. Sætter de nødvendige variabler sammen men navnet til kommandoen og sætter det i køen.
func submit_score(level,score):
	var command = "add_score"
	var data = {"username" : logged_in_username, "score" : score,"level":level}
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
	

#Tæller antallet af levels ved at tælle antal filer i Scenes/Levels mappen. 
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

#Hjælpefunktion til at give brugeren en besked med en bekræftelses popup
func popup_message(message,parentNode):
	var popup_instance=popup.instantiate()
	popup_instance.add_to_group("popup_message")
	popup_instance.get_child(0).set_text(message)
	parentNode.add_child(popup_instance)
