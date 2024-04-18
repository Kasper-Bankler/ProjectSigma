extends Node

class_name BuildingClass

var popup = preload("res://Scenes/Screens/popupmenu_messenger.tscn")




@onready var new_popup=popup.instantiate()
@onready var new_popup_child = new_popup.get_child(0)


@export var Name = "wind"
var upgradeLevel = 1




var wind
var sun

var stats=BuildingData.BUILDINGS_STATS[Name]

#@onready var popup = get_node("UpgradePopupMenu")
@onready var areaNode = get_node("Area2D")
@onready var animatedSprite = get_node("AnimatedSprite2D")
@onready var upgradedLabel = get_node("Area2D/fullyUpgradedLabel")
@onready var insufficientFundsLabel = $Area2D/insufficientFundsLabel
@onready var co2Label = $Area2D/co2Label

# Called when the node enters the scene tree for the first time.
func _ready():
	
	add_to_group("buildings")
	CurrentLevel.emit_signal("new_building_placed")
	
	$".".add_child(new_popup)
	
	wind = CurrentLevel.currentLevel["wind"]
	sun = CurrentLevel.currentLevel["sun"]
	
	new_popup_child.id_pressed.connect(onClickMenu)
	areaNode.input_event.connect(onClick)
	new_popup_child.visible = false
	new_popup_child.add_item("Upgrade for " + str(stats["upgradePrice"]) + "$")
	new_popup_child.add_item("YES",1)
	new_popup_child.add_item("NO",0)
	CurrentLevel.update_balance(-stats["price"])
	
	var timer: Timer = Timer.new()
	timer.autostart = true
	timer.wait_time = 1.0
	timer.timeout.connect(_timer_Timeout)
	$".".add_child(timer)

	if Name == "coal":
		var co2timer: Timer = Timer.new()
		co2timer.autostart = true
		co2timer.wait_time = 1.0
		co2timer.timeout.connect(_co2_timer_Timeout)
		$".".add_child(co2timer)

func _co2_timer_Timeout():
	if CurrentLevel.co2_emitted % 1000 == 0 and not CurrentLevel.co2_emitted == 0:
		var bill = CurrentLevel.co2_emitted*0.01
		CurrentLevel.update_balance(-bill)
		
		co2Label.text = "You just paid "+ str(bill)+ " $ in CO2 tax."
		co2Label.visible = true
		await get_tree().create_timer(3.0).timeout
		co2Label.visible = false


func _timer_Timeout():
	if CurrentLevel.is_playing == true:
		if Name == "wind":
			CurrentLevel.balance += stats["productionRate"]*wind
			CurrentLevel.energy_generated += stats["productionRate"]*0.01*wind
		if Name == "solar":
			CurrentLevel.balance += stats["productionRate"]*sun
			CurrentLevel.energy_generated += stats["productionRate"]*0.01*sun
			CurrentLevel.co2_emitted += stats["emissionRate"]
		else:
			CurrentLevel.balance += stats["productionRate"]
			CurrentLevel.energy_generated += stats["productionRate"]*0.01
			CurrentLevel.co2_emitted += stats["emissionRate"]

func onClick(_viewport, _event, _shape_idx):
	if (Input.is_action_just_pressed("ui_leftclick") and CurrentLevel.is_playing == true):
		upgradeMenu()

func upgradeMenu():
	MusicController.clickSound()
	new_popup_child.position.x = get_viewport().get_mouse_position().x
	new_popup_child.position.y = get_viewport().get_mouse_position().y + 20
	upgradedLabel.visible = false
	new_popup_child.visible = true

func upgradeBuilding(id):
	if id == 1:
		if upgradeLevel == 4:
			MusicController.errorSound()
			upgradedLabel.visible = true
			await get_tree().create_timer(3.0).timeout
			upgradedLabel.visible = false
		elif CurrentLevel.balance >= stats["upgradePrice"]:
			CurrentLevel.emit_signal("building_upgraded")
			MusicController.confirmationSound()
			CurrentLevel.update_balance(-stats["upgradePrice"])
			upgradeLevel += 1
			animatedSprite.play("level" + str(upgradeLevel))
			stats["productionRate"]*=2
			stats["upgradePrice"]*=2
		else:
			MusicController.errorSound()
			insufficientFundsLabel.visible = true
			await get_tree().create_timer(3.0).timeout
			insufficientFundsLabel.visible = false

func onClickMenu(id):
	upgradeBuilding(id)
