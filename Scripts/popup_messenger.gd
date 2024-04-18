extends Control

func _on_accept_dialog_canceled():
	queue_free()


func _on_accept_dialog_confirmed():
	queue_free()
