extends Node

class_name BuildingClass

@export var Name = ""
@export var upgradeLevel = 1
@export var EmissionRate = 0
@export var ProductionRate = 0
@export var Price = 0

@onready var popup = get_node("UpgradePopupMenu")
@onready var areaNode = get_node("Area2D")
@onready var animatedSprite = get_node("AnimatedSprite2D")
@onready var upgradedLabel = get_node("Area2D/fullyUpgradedLabel")

# Called when the node enters the scene tree for the first time.
func _ready():
	popup.id_pressed.connect(onClickMenu)
	areaNode.input_event.connect(onClick)
	popup.visible = false
	popup.add_item("YES",1)
	popup.add_item("NO",0)
	pass # Replace with function body.

func onClick(viewport, event, shape_idx):
	if (Input.is_action_just_pressed("ui_leftclick")):
		upgradedLabel.visible = false
		upgradeMenu()

func upgradeMenu():
	popup.visible = true
	pass

func upgradeBuilding():
	print("test test test")
	pass

func placementHandler():
	pass

func removeMoney():
	pass

func onClickMenu(id):
	if id == 1:
		var currentUpgrade = animatedSprite.animation
		print(currentUpgrade)
		if currentUpgrade == "level4":
			upgradedLabel.visible = true
			
			pass
		else:
			removeMoney()
			print("kom hertil")
			print("level" + str((int(currentUpgrade.right(1)))+1))
			animatedSprite.play("level" + str((int(currentUpgrade.right(1)))+1))

		print("test")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	
	
