extends Area2D

var tier = 1
var upgrade_costs = [475, 650]
var sprite_paths = [
	"res://sprites/Towers/Mage_Tower/Mage_Tower1.png",
	"res://sprites/Towers/Mage_Tower/Mage_Tower2.png",
	"res://sprites/Towers/Mage_Tower/Mage_Tower3.png"
]

var fire_rate = 1.0  # Más lento que el arquero
var fire_timer = 0.0
var target: Node2D = null

var special_chance = 0.15
var special_cooldown = 35.0
var cooldown_timer := 0.0
var special_ready = false

var projectile_scene = preload("res://Proyectiles/Fireball.tscn")
var fire_zone_scene = preload("res://EfectosEspeciales/FireZone.tscn") 

@onready var menu = $UpgradeMenu
@onready var label = $UpgradeMenu/VBoxContainer/Label
@onready var sprite = $Sprite2D
@onready var detection_area = $DetectionArea

func _ready():
	detection_area.monitoring = true
	detection_area.set_deferred("monitoring", true)
	sprite.texture = load(sprite_paths[tier - 1])
	update_fire_rate()
	menu.visible = false
	label.text = "Mejorar a Tier %d - %dG" % [tier + 1, upgrade_costs[0]]
	self.input_event.connect(_on_click)
	$UpgradeMenu/VBoxContainer/Button.pressed.connect(upgrade)
	detection_area.body_exited.connect(_on_body_exited)

	

func _process(delta):
	fire_timer -= delta

	# Enfriamiento de la habilidad especial
	if cooldown_timer > 0.0:
		cooldown_timer -= delta

	get_new_target()

	if target and is_instance_valid(target):
		if fire_timer <= 0:
			fire()
			fire_timer = fire_rate


func get_new_target():
	var best_target = null
	var lowest_resistance = 101  # Mayor que cualquier posible resistencia

	var bodies = detection_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Enemigo") and ("magicResistance" in body):
			var res = body.magicResistance
			if res < lowest_resistance:
				lowest_resistance = res
				best_target = body

	if best_target != target:
		print("🔮 Mage cambia objetivo a:", best_target.name, "con resistencia mágica:", lowest_resistance)
		target = best_target

		# Intentar activar la habilidad si no está en cooldown
		if not special_ready and cooldown_timer <= 0.0 and randf() < special_chance:
			print("🔥 Mage habilidad especial ACTIVADA")
			special_ready = true



func fire():
	if not target or not is_instance_valid(target):
		print("❌ No hay objetivo válido.")
		return

	print("🔥 Torre dispara a:", target.name)
	var p = projectile_scene.instantiate()
	p.global_position = global_position
	p.objetivo = target

	# Daño base según el tier
	match tier:
		1: p.damage = 35
		2: p.damage = 50
		3: p.damage = 75

	p.damage_type = "magic"

	# Verifica si la habilidad especial está activa
	if special_ready:
		print("💥 HABILIDAD ESPECIAL ACTIVADA: Creando zona de fuego")
		special_ready = false
		cooldown_timer = special_cooldown

		# Creamos la zona de fuego en la posición actual del objetivo
		var fire_zone = fire_zone_scene.instantiate()
		fire_zone.global_position = target.global_position
		get_tree().root.get_node("Main").add_child(fire_zone)

	print("🚀 Proyectil creado con daño:", p.damage, "y tipo:", p.damage_type)
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
			update_fire_rate()
			if tier < 3:
				label.text = "Mejorar a Tier %d - %dG" % [tier + 1, upgrade_costs[tier - 1]]
			else:
				menu.visible = false

func _on_body_exited(body):
	if body == target:
		print("⚠️ Target salió del rango:", body.name)
		target = null
		
func update_fire_rate():
	match tier:
		1, 2:
			fire_rate = 1.0
		3:
			fire_rate = 0.7

func try_activate_special():
	if special_ready or cooldown_timer > 0:
		return

	if randf() < special_chance:
		special_ready = true
		print("🔥 Habilidad especial de Mage activada")
