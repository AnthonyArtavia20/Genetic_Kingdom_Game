extends Area2D

var tier = 1
var upgrade_costs = [750, 1000]
var fire_rate = 2.0
var fire_timer = 0.0
var direction = "right"
var target: Node2D = null

var max_ammo = 3
var current_ammo = 3
var reload_time = 3.0
var is_reloading = false
var reload_timer := 0.0

# Especial
var is_special_active = false
var special_chance = 0.1
var special_cooldown = 90.0
var cooldown_timer = 0.0


var projectile_scene = preload("res://Proyectiles/Cannonball.tscn")

@onready var menu = $UpgradeMenu
@onready var label = $UpgradeMenu/VBoxContainer/Label
@onready var button = $UpgradeMenu/VBoxContainer/Button
@onready var anim_sprite = $AnimatedSprite2D
@onready var detection_area = $DetectionArea

func _ready():
	set_ammo_by_tier()
	detection_area.monitoring = true
	detection_area.set_deferred("monitoring", true)
	detection_area.body_exited.connect(_on_body_exited)

	menu.visible = false
	update_anim_idle()
	update_fire_rate()

	label.text = "Mejorar a Tier %d - %dG" % [tier + 1, upgrade_costs[0]]
	self.input_event.connect(_on_click)
	button.pressed.connect(upgrade)

func _process(delta):
	# Cooldown de habilidad especial
	if cooldown_timer > 0:
		cooldown_timer -= delta

	# Proceso de recarga
	if is_reloading:
		reload_timer -= delta
		if reload_timer <= 0:
			print("🔄 Artillery recargada.")
			current_ammo = max_ammo
			is_reloading = false
		return

	fire_timer -= delta
	get_new_target()

	if target and is_instance_valid(target):
		if fire_timer <= 0 and current_ammo > 0:
			fire()
			fire_timer = fire_rate

			# Finalizar habilidad especial al quedarse sin munición
			if is_special_active and current_ammo == 0:
				is_special_active = false
				cooldown_timer = special_cooldown
				print("⛔ Fin de habilidad especial. Entra en cooldown.")

		elif current_ammo == 0 and not is_reloading:
			is_reloading = true
			reload_timer = reload_time

func get_new_target():
	var best_target = null
	var lowest_resistance = 101  # Un valor mayor al máximo esperado

	var bodies = detection_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("Enemigo") and ("artilleryResistance" in body):
			var res = body.artilleryResistance
			if res < lowest_resistance:
				lowest_resistance = res
				best_target = body

	if best_target != target:
		print("💥 Artillery cambia objetivo a:", best_target.name, "con resistencia de artillería:", lowest_resistance)
		target = best_target
		try_activate_special()

func fire():
	if not target or not is_instance_valid(target):
		return

	if current_ammo <= 0:
		print("⏳ Sin munición en Artillery. Recargando...")
		is_reloading = true
		reload_timer = reload_time
		return

	# ↓ Se descuenta munición justo antes de disparar
	current_ammo -= 1

	# Determinar dirección para animación
	var dir_vector = (target.global_position - global_position).normalized()
	direction = "left" if dir_vector.x < 0 else "right"

	var anim_name = "tier%d_%s" % [tier, direction]
	if anim_sprite.sprite_frames.has_animation(anim_name):
		anim_sprite.play(anim_name)
	else:
		print("⚠️ Animación no encontrada:", anim_name)

	# Crear proyectil
	var p = projectile_scene.instantiate()
	p.global_position = global_position
	p.objetivo = target
	p.damage_type = "artillery"

	# Asignar daño base por tier
	match tier:
		1: p.damage = 65
		2: p.damage = 90
		3: p.damage = 130

	# Si está activa la habilidad especial, duplicar el daño
	if is_special_active:
		p.damage *= 2
		print("💥 HABILIDAD ESPECIAL: Doble daño =", p.damage)

	get_tree().root.get_node("Main").add_child(p)

func upgrade():
	if tier < 3:
		var cost = upgrade_costs[tier - 1]
		var main = get_tree().root.get_node("Main")
		if main.current_gold >= cost:
			main.current_gold -= cost
			tier += 1
			update_fire_rate()
			update_anim_idle()
			set_ammo_by_tier()
			if tier == 2:
				main.level_two_towers += 1
			if tier < 3:
				label.text = "Mejorar a Tier %d - %dG" % [tier + 1, upgrade_costs[tier - 1]]
			else:
				menu.visible = false
		if tier == 3:
			main.level_three_towers += 1

func update_fire_rate():
	match tier:
		1: fire_rate = 2.0
		2: fire_rate = 2.0
		3: fire_rate = 1.75

func update_anim_idle():
	var idle_anim = "tier%d_%s" % [tier, direction]
	if anim_sprite.sprite_frames.has_animation(idle_anim):
		anim_sprite.play(idle_anim)
		anim_sprite.pause()
		anim_sprite.frame = 0

func _on_AnimatedSprite2D_animation_finished():
	update_anim_idle()

func _on_click(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		menu.visible = !menu.visible

func _on_body_exited(body):
	if body == target:
		target = null
		
func set_ammo_by_tier():
	match tier:
		1: max_ammo = 3
		2: max_ammo = 4
		3: max_ammo = 5
	current_ammo = max_ammo

func try_activate_special():
	if is_special_active or cooldown_timer > 0:
		return

	if randf() < special_chance:
		print("💥 Artillery habilidad especial ACTIVADA")
		is_special_active = true
		current_ammo = max_ammo  # Cargar a full
