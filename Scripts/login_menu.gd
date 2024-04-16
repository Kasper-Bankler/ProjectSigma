extends Control

var username = ""
var password



func _process(delta):
	if UserData.is_requesting:
		$Login.set_text("Loading...")
	else:
		$Login.set_text("Sign up")
		

func _on_login_button_down():
	if $Username.get_text()=="":
		UserData.popup_message("Please enter a username",$".")
		return
		
	if $Password.get_text()=="":
		UserData.popup_message("Please enter a password",$".")
		return
		
	if !UserData.is_requesting:
		username = $Username.get_text()
		password = $Password.get_text()
		UserData.register_new_user(username,password)


		$Username.text = ""
		$Password.text = ""
	
		
