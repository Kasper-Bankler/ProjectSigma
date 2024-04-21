extends Node

class_name BuildingClass

var popup = preload("res://Scenes/Screens/popupmenu_messenger.tscn")
@export var Name = ""
var upgradeLevel = 1
var wind
var sun
@onready var stats=BuildingData.BUILDINGS_STATS[Name].duplicate()
@onready var areaNode = get_node("Area2D")
@onready var animatedSprite = get_node("AnimatedSprite2D")
@onready var upgradedLabel = get_node("Area2D/fullyUpgradedLabel")
@onready var insufficientFundsLabel = $Area2D/insufficientFundsLabel
var upgrade_bool=false

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer=Timer.new()
	timer.wait_time=1
	timer.autostart=true
	timer.timeout.connect(set_upgrade_bool)
	$".".add_child(timer)
	
	# Tilføjer bygningen til gruppen buildings og sender et signal til levelet
	add_to_group("buildings")
	CurrentLevel.emit_signal("new_building_placed")
	
	# Henter vind og sol variablerne fra currentLevel autoload
	wind = CurrentLevel.currentLevel["wind"]
	sun = CurrentLevel.currentLevel["sun"]
	
	# Signalet emittes når der klikkes på en bygning
	areaNode.input_event.connect(onClick)

func set_upgrade_bool():
	upgrade_bool=true
	

func generate_upgrade_popup():
	# Tilføjer en upgrade popup
	var new_popup=popup.instantiate()
	var new_popup_child=new_popup.get_child(0)
	new_popup_child.id_pressed.connect(onClickMenu)
	new_popup_child.add_item("Upgrade for " + str(stats["upgradePrice"]) + "$")
	new_popup_child.add_item("YES",1)
	new_popup_child.add_item("NO",0)
	new_popup.get_child(0).position=get_viewport().get_mouse_position()
	$".".add_child(new_popup)

func onClick(_viewport, _event, _shape_idx):
	# Tjekker om inputet er venstreklik og om spillet er igang
	if (Input.is_action_just_pressed("ui_leftclick") and CurrentLevel.is_playing == true):
		upgradeMenu()

func upgradeMenu():
	if (!upgrade_bool):
		return
	# Hvis bygningen er fuldt opgraderet
	if upgradeLevel == 4:
		MusicController.errorSound()
		upgradedLabel.visible = true
		await get_tree().create_timer(3.0).timeout
		upgradedLabel.visible = false
		return
	# Hvis bygningen ikke er fuldt opgraderet
	MusicController.clickSound()
	upgradedLabel.visible = false
	generate_upgrade_popup()

func upgradeBuilding(id):
	if id == 1:
		# Hvis brugeren har råd til bygningen opgraderes den
		if CurrentLevel.balance >= stats["upgradePrice"]:
			CurrentLevel.emit_signal("building_upgraded")
			stats["upgradePrice"]=stats["upgradePrice"]*2
			MusicController.confirmationSound()
			upgradeLevel += 1
			animatedSprite.play("level" + str(upgradeLevel))
			stats["productionRate"]*=2
		# Ellers vises en fejlmeddelelse
		else:
			MusicController.errorSound()
			insufficientFundsLabel.visible = true
			await get_tree().create_timer(3.0).timeout
			insufficientFundsLabel.visible = false

func onClickMenu(id):
	upgradeBuilding(id)
