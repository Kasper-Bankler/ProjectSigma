extends Node

class_name BuildingClass

var popup = preload("res://Scenes/Screens/popupmenu_messenger.tscn")






@export var Name = "wind"
var upgradeLevel = 1




var wind
var sun

@onready var stats=BuildingData.BUILDINGS_STATS[Name].duplicate()

#@onready var popup = get_node("UpgradePopupMenu")
@onready var areaNode = get_node("Area2D")
@onready var animatedSprite = get_node("AnimatedSprite2D")
@onready var upgradedLabel = get_node("Area2D/fullyUpgradedLabel")
@onready var insufficientFundsLabel = $Area2D/insufficientFundsLabel
@onready var co2Label = $Area2D/co2Label

var upgrade_bool=false

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer=Timer.new()
	
	timer.wait_time=1
	timer.autostart=true
	timer.timeout.connect(set_upgrade_bool)
	$".".add_child(timer)
	
	add_to_group("buildings")
	CurrentLevel.emit_signal("new_building_placed")
	
	
	
	wind = CurrentLevel.currentLevel["wind"]
	sun = CurrentLevel.currentLevel["sun"]
	
	
	
	areaNode.input_event.connect(onClick)
	
	
	

func set_upgrade_bool():
	upgrade_bool=true
	

func generate_upgrade_popup():
	var new_popup=popup.instantiate()
	var new_popup_child=new_popup.get_child(0)
	new_popup_child.id_pressed.connect(onClickMenu)
	new_popup_child.add_item("Upgrade for " + str(stats["upgradePrice"]) + "$")
	new_popup_child.add_item("YES",1)
	new_popup_child.add_item("NO",0)
	print("idiot alu")
	print(get_viewport().get_mouse_position())
	var postion = Vector2(get_viewport().get_mouse_position().x,get_viewport().get_mouse_position().y)
	new_popup.position.x=get_viewport().get_mouse_position().x
	new_popup.position.y=get_viewport().get_mouse_position().y+20
	

	
	$".".add_child(new_popup)

func onClick(_viewport, _event, _shape_idx):
	if (Input.is_action_just_pressed("ui_leftclick") and CurrentLevel.is_playing == true):
		upgradeMenu()


func upgradeMenu():
	if (!upgrade_bool):
		return
	if upgradeLevel == 4:
		MusicController.errorSound()
		upgradedLabel.visible = true
		await get_tree().create_timer(3.0).timeout
		upgradedLabel.visible = false
		return
	MusicController.clickSound()
	upgradedLabel.visible = false
	generate_upgrade_popup()

func upgradeBuilding(id):
	
	
	if id == 1:
		
		if CurrentLevel.balance >= stats["upgradePrice"]:
			print("UPGRADE")
			CurrentLevel.emit_signal("building_upgraded")
			
			stats["upgradePrice"]=stats["upgradePrice"]*2
			MusicController.confirmationSound()
			
			upgradeLevel += 1
			animatedSprite.play("level" + str(upgradeLevel))
			stats["productionRate"]*=2
			
		else:
			MusicController.errorSound()
			insufficientFundsLabel.visible = true
			await get_tree().create_timer(3.0).timeout
			insufficientFundsLabel.visible = false

func onClickMenu(id):
	upgradeBuilding(id)
