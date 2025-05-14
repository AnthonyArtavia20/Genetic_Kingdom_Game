extends Area2D

var tier = 1
var upgrade_costs = [200, 300]
var sprite_paths = [
	"res://sprites/Towers/Archer_Tower/Archer_Tower1.png",
	"res://sprites/Towers/Archer_Tower/Archer_Tower2.png",
	"res://sprites/Towers/Archer_Tower/Archer_Tower3.png"
]

var fire_rate = 1.0  # segundos entre disparos
var fire_timer = 0.0
var target: Node2D = null

var projectile_scene = preload("res://Proyectiles/Proyectil.tscn")

@onready var menu = $UpgradeMenu
@onready var label = $UpgradeMenu/VBoxContainer/Label
@onready var sprite = $Sprite2D
@onready var detection_area = $DetectionArea

func _ready():
	detection_area.monitoring = true
	detection_area.set_deferred("monitoring", true)
	menu.visible = false
	label.text = "Mejorar a Tier %d - %dG" % [tier + 1, upgrade_costs[0]]
	self.input_event.connect(_on_click)
	$UpgradeMenu/VBoxContainer/Button.pressed.connect(upgrade)

func _process(delta):
	fire_timer -= delta

	if target and target.is_inside_tree():
		look_at(target.global_position)
		if fire_timer <= 0:
			fire()
			fire_timer = fire_rate
	else:
		get_new_target()

func get_new_target():
	if detection_area:
		print("DetectionArea existe.")
	else:
		print("❌ No hay DetectionArea!")

	var bodies = detection_area.get_overlapping_bodies()
	print("Cantidad de cuerpos detectados:", bodies.size())

	for body in bodies:
		print("👀 En área:", body.name)
		if body.is_in_group("Enemigo"):
			print("🎯 Torre detecta:", body.name)
			target = body
			break



func fire():
	if not target:
		return
	print("🔥 Torre dispara a:", target.name)
	var p = projectile_scene.instantiate()
	p.global_position = global_position
	p.objetivo = target
	get_tree().root.get_node("Main").add_child(p)


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
