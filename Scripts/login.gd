extends Control

@onready var usernameField = $VBoxContainer/HBoxContainer2/Username
@onready var passwordField = $VBoxContainer/HBoxContainer/Password
@onready var loginButton = $VBoxContainer/Login
var username
var password

func _ready():
	UserData.log_in_response.connect(on_login_response)
	
	
func _process(delta):
	
	#Ændrer knappen til Loading hvis i gang med at hente brugerdata fra db
	if UserData.is_requesting:
		loginButton.set_text("Loading...")
		loginButton.disabled=true
	else:
		loginButton.set_text("Login")
		loginButton.disabled=false

func _on_login_pressed():

	#Giver popup hvis et af felterne er tomt
	
	
	
	
	#Forsøger at finde bruger med den indtastede adgangskode og logind
	
	username = usernameField.get_text().strip_edges(true,true)
	password = passwordField.get_text().strip_edges(true,true)
	
	if password=="":
		MusicController.errorSound()
		UserData.popup_message("Husk at vælge et brugernavn!",$".")
		return
		
	if username=="":
		MusicController.errorSound()
		UserData.popup_message("Husk at vælge en adgangskode!",$".")
		return
		
	UserData.login_user(username,password)

func on_login_response(res):
	
	#Hvis objectet er tom er det fordi der ikke eksisterede nogen bruger med det indtastede brugernavn
	
	if ("username" not in res):
		MusicController.errorSound()
		UserData.popup_message("Ingen bruger fundet med indtastede brugernavn!",$".")
		return
	
	#Giver brugeren besked hvis adgangskode ikke er korrekt
	
	elif (res["password"]!=res["input_password"]):
		MusicController.errorSound()
		UserData.popup_message("Den indtastede adgangskode er forkert!",$".")
		return
	
	#Logger brugeren ind til spillet
	
	UserData.logged_in_username=res["username"]
	get_tree().change_scene_to_file("res://Scenes/Screens/StartMenu.tscn")
#Skifter scene til bruger registreringsside

func _on_login_2_pressed():
	MusicController.clickSound()
	get_tree().change_scene_to_file("res://Scenes/Screens/signup.tscn")
