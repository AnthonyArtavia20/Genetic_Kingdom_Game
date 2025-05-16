extends Area2D

var tier = 1
var upgrade_costs = [300, 475]
var sprite_paths = [
	"res://sprites/Towers/Archer_Tower/Archer_Tower1.png",
	"res://sprites/Towers/Archer_Tower/Archer_Tower2.png",
	"res://sprites/Towers/Archer_Tower/Archer_Tower3.png"
]

var fire_rate = 0.5  # segundos entre disparos
var fire_timer = 0.0
var target: Node2D = null

var max_ammo = 10
var current_ammo = 10
var reload_time = 1.0
var is_reloading = false
var reload_timer := 0.0

# Habilidad especial
var special_chance = 0.2  # 20% de probabilidad de activarse al detectar enemigo
var special_cooldown = 15.0  # segundos de espera para volver a activarse
var is_special_active = false
var cooldown_timer = 0.0


var projectile_scene = preload("res://Proyectiles/Proyectil.tscn")

@onready var menu = $UpgradeMenu
@onready var label = $UpgradeMenu/VBoxContainer/Label
@onready var sprite = $Sprite2D
@onready var detection_area = $DetectionArea

func _ready():
	set_ammo_by_tier()
	detection_area.monitoring = true
	detection_area.set_deferred("monitoring", true)
	menu.visible = false
	label.text = "Mejorar a Tier %d - %dG" % [tier + 1, upgrade_costs[0]]
	self.input_event.connect(_on_click)
	$UpgradeMenu/VBoxContainer/Button.pressed.connect(upgrade)
	detection_area.body_exited.connect(_on_body_exited)


func _process(delta):
	# Actualizar cooldown de habilidad especial
	if cooldown_timer > 0:
		cooldown_timer -= delta

	# Manejo de recarga
	if is_reloading:
		reload_timer -= delta
		if reload_timer <= 0:
			print("🔄 Torre recargada.")
			current_ammo = max_ammo
			is_reloading = false
		return

	# Disparo
	fire_timer -= delta
	get_new_target()

	if target and is_instance_valid(target):
		if fire_timer <= 0 and current_ammo > 0:
			print("🚀 Disparando a:", target.name)
			fire()
			fire_timer = fire_rate

			# Si se acaba la munición y estaba en modo especial, se termina la habilidad
			if is_special_active and current_ammo == 0:
				print("⛔ Habilidad especial finalizada. Volviendo a estado normal.")
				is_special_active = false
				fire_rate = 0.5
				cooldown_timer = special_cooldown

		# Si se acaba munición (ya sea con o sin habilidad especial), se recarga
		elif current_ammo == 0 and not is_reloading:
			print("🔋 Munición agotada. Iniciando recarga.")
			is_reloading = true
			reload_timer = reload_time
	else:
		target = null



func get_new_target():
	var best_target = null
	var lowest_resistance = 101

	var bodies = detection_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Enemigo") and "arrowResistance" in body:
			var res = body.arrowResistance
			if res < lowest_resistance:
				lowest_resistance = res
				best_target = body

	if best_target != target:
		if best_target:
			print("🎯 Nuevo objetivo:", best_target.name, "con resistencia:", lowest_resistance)
		target = best_target
		try_activate_special()

func fire():
	if not target or not is_instance_valid(target):
		print("❌ No hay objetivo válido.")
		return
		
	if current_ammo <= 0:
		print("⏳ Sin munición. Recargando...")
		is_reloading = true
		reload_timer = reload_time
		return

	current_ammo -= 1

	print("🔥 Torre dispara a:", target.name)
	var p = projectile_scene.instantiate()
	p.global_position = global_position
	p.objetivo = target

	match tier:
		1: p.damage = 15
		2: p.damage = 30
		3: p.damage = 55

	p.damage_type = "arrow"  # 👈 Tipo de daño especificado

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
			fire_rate = 0.5
			set_ammo_by_tier()
			if tier < 3:
				label.text = "Mejorar a Tier %d - %dG" % [tier + 1, upgrade_costs[tier - 1]]
			else:
				menu.visible = false
				
func _on_body_exited(body):
	if body == target:
		print("⚠️ Target salió del rango:", body.name)
		target = null
		
func set_ammo_by_tier():
	match tier:
		1: max_ammo = 10
		2: max_ammo = 15
		3: max_ammo = 20
	current_ammo = max_ammo  # recargar al comenzar o mejorar
	
func try_activate_special():
	if is_special_active or cooldown_timer > 0:
		return

	if randf() < special_chance:
		print("⚡ Habilidad especial del Archer ACTIVADA")
		is_special_active = true
		fire_rate = 0.2
		current_ammo = max_ammo
