extends Control

var username = ""
var password

var created = false



func _on_login_button_down():
	if !created:
		username = $Username.text
		password = $Password.text.sha256_text
		created = true
		print("Account created")
