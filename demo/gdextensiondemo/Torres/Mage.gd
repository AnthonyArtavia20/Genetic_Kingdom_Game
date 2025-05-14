extends Area2D

var tier = 1
var upgrade_costs = [250, 400]
var sprite_paths = [
	"res://sprites/Towers/Mage_Tower/Mage_Tower1.png",
	"res://sprites/Towers/Mage_Tower/Mage_Tower2.png",
	"res://sprites/Towers/Mage_Tower/Mage_Tower3.png"
]

@onready var menu = $UpgradeMenu
@onready var label = $UpgradeMenu/VBoxContainer/Label
@onready var sprite = $Sprite2D

func _ready():
	menu.visible = false
	sprite.texture = load(sprite_paths[tier - 1])
	label.text = "Mejorar a Tier %d - %dG" % [tier + 1, upgrade_costs[0]]
	self.input_event.connect(_on_click)
	$UpgradeMenu/VBoxContainer/Button.pressed.connect(upgrade)

func _on_click(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		menu.visible = !menu.visible

func upgrade():
	if tier < 3:
		var cost = upgrade_costs[tier - 1]
		var main = get_tree().root.get_node("Main")
		if main.current_gold >= cost:
			main.current_gold -= cost
			tier += 1
			sprite.texture = load(sprite_paths[tier - 1])
			if tier < 3:
				label.text = "Mejorar a Tier %d - %dG" % [tier + 1, upgrade_costs[tier - 1]]
			else:
				menu.visible = false
