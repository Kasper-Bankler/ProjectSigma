extends Control

var username = ""
var password

var created = false



func _on_login_button_down():
	if !created:
		username = $Username.text
		password = $Password.text.sha256_text()
		created = true
		$Login.text = "Login"
		$Username.text = ""
		$Password.text = ""
		print("Account created")
	else:
		if $Username.text == username:
			if $Password.text.sha256_text() == password:
				print("Login Success!")
				get_tree().change_scene_to_file("res://Scenes/Screens/menu.tscn")
			else:
				print("Login failed!")
		else:
				print("Login failed again!")
