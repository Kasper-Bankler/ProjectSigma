extends Control

var username = ""
var password

@onready var usernameField =$Username
@onready var passwordField =$Password


func _ready():
	UserData.connect("signed_up",signed_up)


func signed_up():
	get_tree().change_scene_to_file("res://Scenes/Screens/login.tscn")
	
func _process(delta):
	if UserData.is_requesting:
		$Login.set_text("Loading...")
	else:
		$Login.set_text("Sign up")
		

func _on_login_button_down():
	if usernameField.get_text()=="":
		UserData.popup_message("Please enter a username",$".")
		return
		
	if passwordField.get_text()=="":
		UserData.popup_message("Please enter a password",$".")
		return
		
	if !UserData.is_requesting:
		username = usernameField.get_text()
		password = passwordField.get_text()
		UserData.register_new_user(username,password)
		

		$Username.text = ""
		$Password.text = ""
	
		


func _on_login_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/Screens/login.tscn")
