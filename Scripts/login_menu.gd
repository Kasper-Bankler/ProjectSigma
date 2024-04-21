extends Control

var username = ""
var password

@onready var usernameField = $VBoxContainer/HBoxContainer2/Username
@onready var passwordField = $VBoxContainer/HBoxContainer/Password
@onready var signup_button = $VBoxContainer/Login2

func _ready():
	UserData.connect("signed_up",signed_up)


func signed_up(encountered_error):
	
	#Kontrolleret error om allerede brugt brugernavn håndteres
	if encountered_error:
		UserData.popup_message("Der eksisterer en anden bruger med det valgte brugernavn!",$".")
		return
	
	#Det er lykkes at registrere en ny bruger og brugeren sendes til login side 
	MusicController.confirmationSound()
	get_tree().change_scene_to_file("res://Scenes/Screens/login.tscn")
	
func _process(delta):
	
		#Ændrer knappen til Loading hvis i gang med at hente brugerdata fra db
	if UserData.is_requesting:
		signup_button.set_text("Loading...")
		signup_button.disabled=true
	else:
		$VBoxContainer/Login2.set_text("Sign up")
		signup_button.disabled=false
		

func _on_login_button_down():
	
	var input_password = passwordField.get_text()
	var input_username = usernameField.get_text()
	
	#Giver popup hvis et af felterne er tomt
	
	if input_username=="":
		MusicController.errorSound()
		UserData.popup_message("Husk at vælge et brugernavn!",$".")
		return
		
	if input_password=="":
		MusicController.errorSound()
		UserData.popup_message("Husk at vælge en adgangskode!",$".")
		return
		
	#Giver popup besked hvis et af felterne er ugyldigt
	
	if input_username.contains(" ") or not input_username.is_valid_filename():
		MusicController.errorSound()
		UserData.popup_message("Ugyldigt brugernavn!",$".")
		return
	if input_password.contains(" ") or not input_password.is_valid_filename():
		MusicController.errorSound()
		UserData.popup_message("Ugyldigt brugernavn!",$".")
		return
		
		
	#Forsøger at registrerw brugeren i db
	
	UserData.register_new_user(input_username,input_password)
	
	#Tømmer begge input felter
	
	usernameField.text = ""
	passwordField.text = ""

#Skifter scene til login siden

func _on_login_2_pressed():
	MusicController.clickSound()
	get_tree().change_scene_to_file("res://Scenes/Screens/login.tscn")
