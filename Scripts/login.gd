extends Control

@onready var usernameField =$Username
@onready var passwordField =$Password

var username
var password

func _process(delta):
	if UserData.is_requesting:
		$Login.set_text("Loading...")
	else:
		$Login.set_text("Login")
		


	


func _on_login_pressed():
	print("test")
	if usernameField.get_text()=="":
		UserData.popup_message("Please enter a username",$".")
		return
		
	if passwordField.get_text()=="":
		UserData.popup_message("Please enter a password",$".")
		return
		
	if !UserData.is_requesting:
		username = usernameField.get_text()
		password = passwordField.get_text()
		UserData.login_user(username,password)


func _on_login_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/signup.tscn")
