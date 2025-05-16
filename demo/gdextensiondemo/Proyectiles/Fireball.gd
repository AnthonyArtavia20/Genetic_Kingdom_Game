extends Area2D

var velocidad = 400
var objetivo: Node2D = null
var damage = 10  # Daño base. Se puede cambiar desde la torre.
var damage_type = "magic"

func _process(delta):
	if not objetivo or not is_instance_valid(objetivo):
		queue_free()
		return

	# Apunta hacia el objetivo
	look_at(objetivo.global_position)
	rotation += deg_to_rad(90)  # Ajusta 90 grados si tu sprite apunta horizontalmente

	# Movimiento
	position += (objetivo.global_position - position).normalized() * velocidad * delta

	# Verifica si impactó
	if position.distance_to(objetivo.global_position) < 8:
		if objetivo.has_method("take_damage"):
			objetivo.take_damage(damage, damage_type)
		queue_free()
