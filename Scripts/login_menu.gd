extends Control

var username = ""
var password

@onready var usernameField =$VBoxContainer/HBoxContainer2/Username
@onready var passwordField =$VBoxContainer/HBoxContainer/Password


func _ready():
	UserData.connect("signed_up",signed_up)


func signed_up():
	MusicController.confirmationSound()
	get_tree().change_scene_to_file("res://Scenes/Screens/login.tscn")
	
func _process(delta):
	if UserData.is_requesting:
		$VBoxContainer/Login2.set_text("Loading...")
	else:
		$VBoxContainer/Login2.set_text("Sign up")
		

func _on_login_button_down():
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
		UserData.register_new_user(username,password)
		
		usernameField.text = ""
		passwordField.text = ""


func _on_login_2_pressed():
	MusicController.clickSound()
	get_tree().change_scene_to_file("res://Scenes/Screens/login.tscn")
