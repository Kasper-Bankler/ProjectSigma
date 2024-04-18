extends Control

@onready var usernameField =$Username
@onready var passwordField =$Password

var username
var password

func _ready():
	UserData.log_in_response.connect(on_login_response)
func _process(delta):
	if UserData.is_requesting:
		$Login.set_text("Loading...")
	else:
		$Login.set_text("Login")


func _on_login_pressed():
	if usernameField.get_text()=="":
		MusicController.errorSound()
		UserData.popup_message("Please enter a username",$".")
		return
		
	if passwordField.get_text()=="":
		MusicController.errorSound()
		UserData.popup_message("Please enter a password",$".")
		return
		
	if !UserData.is_requesting:
		username = usernameField.get_text()
		password = passwordField.get_text()
		UserData.login_user(username,password)

func on_login_response(res):
	if ("username" not in res):
		MusicController.errorSound()
		UserData.popup_message("User doesnt exist!",$".")
		return
			
	elif (res["password"]!=res["input_password"]):
		MusicController.errorSound()
		UserData.popup_message("wrong password!",$".")
		return
	UserData.logged_in_username=res["username"]
	get_tree().change_scene_to_file("res://Scenes/Screens/StartMenu.tscn")

func _on_login_2_pressed():
	MusicController.clickSound()
	get_tree().change_scene_to_file("res://Scenes/Screens/signup.tscn")
