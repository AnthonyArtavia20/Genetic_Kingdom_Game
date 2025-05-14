extends Area2D

var tier = 1
var upgrade_costs = [500, 800]
var direction = "right"  # "right" o "left"

@onready var menu = $UpgradeMenu
@onready var label = $UpgradeMenu/VBoxContainer/Label
@onready var button = $UpgradeMenu/VBoxContainer/Button
@onready var anim_sprite = $AnimatedSprite2D

func _ready():
	menu.visible = false

	var anim_name = "tier%d_%s" % [tier, direction]
	if anim_sprite.sprite_frames.has_animation(anim_name):
		anim_sprite.animation = anim_name
		anim_sprite.frame = 0  # Mostrar solo el primer frame
		anim_sprite.stop()
	else:
		print("⚠️ Animación no encontrada:", anim_name)

	label.text = "Mejorar a Tier %d - %dG" % [tier + 1, upgrade_costs[0]]
	self.input_event.connect(_on_click)
	button.pressed.connect(upgrade)



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
			anim_sprite.play("tier%d_%s" % [tier, direction])
			if tier < 3:
				label.text = "Mejorar a Tier %d - %dG" % [tier + 1, upgrade_costs[tier - 1]]
			else:
				menu.visible = false

func set_direction(new_direction):
	if direction != new_direction:
		direction = new_direction
		anim_sprite.play("tier%d_%s" % [tier, direction])
		
func shoot_towards(target_position: Vector2):
	var to_target = target_position - global_position
	var dir = to_target.normalized()
	
	# Determina izquierda o derecha
	if dir.x < 0:
		set_direction("left")
	else:
		set_direction("right")

	# Reproducir la animación de disparo
	var anim_name = "tier%d_%s" % [tier, direction]
	anim_sprite.play(anim_name)
	
func _on_AnimatedSprite2D_animation_finished():
	# Volver a la posición de espera
	anim_sprite.frame = 0
	anim_sprite.stop()
