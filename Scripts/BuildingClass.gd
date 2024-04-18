extends Node

class_name BuildingClass

var popup = preload("res://Scenes/Screens/popupmenu_messenger.tscn")

@onready var new_popup=popup.instantiate()
@onready var new_popup_child = new_popup.get_child(0)


@export var Name = "wind"
var upgradeLevel = 1
var emissionRate
var productionRate
var price
var upgradePrice


#@onready var popup = get_node("UpgradePopupMenu")
@onready var areaNode = get_node("Area2D")
@onready var animatedSprite = get_node("AnimatedSprite2D")
@onready var upgradedLabel = get_node("Area2D/fullyUpgradedLabel")
@onready var insufficientFundsLabel = $Area2D/insufficientFundsLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	$".".add_child(new_popup)
	
	print(BuildingData.BUILDINGS_STATS[Name])
	emissionRate=BuildingData.BUILDINGS_STATS[Name]["emissionRate"]
	productionRate=BuildingData.BUILDINGS_STATS[Name]["productionRate"]
	price=BuildingData.BUILDINGS_STATS[Name]["price"]
	upgradePrice=BuildingData.BUILDINGS_STATS[Name]["upgradePrice"]
	
	new_popup_child.id_pressed.connect(onClickMenu)
	areaNode.input_event.connect(onClick)
	new_popup_child.visible = false
	new_popup_child.add_item("Upgrade ")
	new_popup_child.add_item("YES",1)
	new_popup_child.add_item("NO",0)
	CurrentLevel.update_balance(-price)
	
	var timer: Timer = Timer.new()
	timer.autostart = true
	timer.wait_time = 1.0
	timer.timeout.connect(_timer_Timeout)
	$".".add_child(timer)

func _timer_Timeout():
	CurrentLevel.balance += productionRate
	CurrentLevel.energy_generated += productionRate*0.01

func onClick(viewport, event, shape_idx):
	if (Input.is_action_just_pressed("ui_leftclick")):
		new_popup_child.position.x = get_viewport().get_mouse_position().x
		new_popup_child.position.y = get_viewport().get_mouse_position().y + 20
		upgradedLabel.visible = false
		upgradeMenu()

func upgradeMenu():
	new_popup_child.visible = true

func upgradeBuilding(id):
	if id == 1:
		if upgradeLevel == 4:
			upgradedLabel.visible = true
			await get_tree().create_timer(3.0).timeout
			upgradedLabel.visible = false
		elif CurrentLevel.balance >= upgradePrice:
			CurrentLevel.update_balance(-upgradePrice)
			upgradeLevel += 1
			animatedSprite.play("level" + str(upgradeLevel))
			productionRate*=2
			upgradePrice*=2
		else:
			insufficientFundsLabel.visible = true
			await get_tree().create_timer(3.0).timeout
			insufficientFundsLabel.visible = false

func onClickMenu(id):
	upgradeBuilding(id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

