extends HSlider

var bus_index

func _ready() -> void:
	bus_index = AudioServer.get_bus_index("Master")
	value_changed.connect(_on_changed)
	value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_index)
	)

func _on_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)
	
