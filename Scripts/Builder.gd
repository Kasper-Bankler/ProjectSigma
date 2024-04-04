extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tile = local_to_map(get_global_mouse_position())
	if (Input.is_action_just_pressed("ui_accept")):
		print("det virkede");
		set_cell(0,tile,0,Vector2(0,0),0)


