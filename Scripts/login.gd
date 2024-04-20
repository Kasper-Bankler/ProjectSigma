extends Control

@onready var usernameField =$VBoxContainer/HBoxContainer2/Username
@onready var passwordField =$VBoxContainer/HBoxContainer/Password

var username
var password

func _ready():
	UserData.log_in_response.connect(on_login_response)
func _process(delta):
	if UserData.is_requesting:
		$VBoxContainer/Login.set_text("Loading...")
	else:
		$VBoxContainer/Login.set_text("Login")


func _on_login_pressed():

	if usernameField.get_text()=="":
		MusicController.errorSound()
		UserData.popup_message("Husk at vælge et brugernavn!",$".")
		return
		
	if passwordField.get_text()=="":
		MusicController.errorSound()
		UserData.popup_message("Husk at vælge en adgangskode!",$".")
		return
		
	if !UserData.is_requesting:
		username = usernameField.get_text()
		password = passwordField.get_text()
		UserData.login_user(username,password)

func on_login_response(res):
	if ("username" not in res):
		MusicController.errorSound()
		UserData.popup_message("Ingen bruger fundet med indtastede brugernavn!",$".")
		return
			
	elif (res["password"]!=res["input_password"]):
		MusicController.errorSound()
		UserData.popup_message("Den indtastede adgangskode er forkert!",$".")
		return
	UserData.logged_in_username=res["username"]
	get_tree().change_scene_to_file("res://Scenes/Screens/StartMenu.tscn")

func _on_login_2_pressed():
	MusicController.clickSound()
	get_tree().change_scene_to_file("res://Scenes/Screens/signup.tscn")
