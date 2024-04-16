extends Node

class_name BuildingClass

@export var Name = ""
@export var upgradeLevel = 1
@export var emissionRate = 0
@export var productionRate = 0
@export var price = 100
@export var upgradePrice = 50

@onready var popup = get_node("UpgradePopupMenu")
@onready var areaNode = get_node("Area2D")
@onready var animatedSprite = get_node("AnimatedSprite2D")
@onready var upgradedLabel = get_node("Area2D/fullyUpgradedLabel")

# Called when the node enters the scene tree for the first time.
func _ready():
	popup.id_pressed.connect(onClickMenu)
	areaNode.input_event.connect(onClick)
	popup.visible = false
	popup.add_item(" ")
	popup.add_item("YES",1)
	popup.add_item("NO",0)
	UserData.update_balance(-price)

func onClick(viewport, event, shape_idx):
	if (Input.is_action_just_pressed("ui_leftclick")):
		popup.position.x = get_viewport().get_mouse_position().x
		popup.position.y = get_viewport().get_mouse_position().y + 20
		upgradedLabel.visible = false
		upgradeMenu()

func upgradeMenu():
	popup.visible = true

func upgradeBuilding(id):
	if id == 1:
		var currentUpgrade = animatedSprite.animation
		print(currentUpgrade)
		if currentUpgrade == "level4":
			upgradedLabel.visible = true
			await get_tree().create_timer(3.0).timeout
			upgradedLabel.visible = false

		else:
			UserData.update_balance(-upgradePrice)
			print("level" + str((int(currentUpgrade.right(1)))+1))
			animatedSprite.play("level" + str((int(currentUpgrade.right(1)))+1))
			upgradePrice*=2

func onClickMenu(id):
	upgradeBuilding(id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
