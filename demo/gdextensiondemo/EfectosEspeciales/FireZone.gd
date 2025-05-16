extends Area2D

@onready var timer = $Timer
@onready var center_sprite = $CenterSprite

const DAMAGE = 21
const DURATION = 7.0
const SPRITE_COUNT = 8
const RADIUS = 48.0

func _ready():
	timer.timeout.connect(_on_Timer_timeout)  # ✅ conexión por código
	timer.start(DURATION)
	create_visual_ring()

func _on_Timer_timeout():
	queue_free()

func _process(delta):
	for body in get_overlapping_bodies():
		if body.is_in_group("Enemigo") and body.has_method("take_damage"):
			body.take_damage(DAMAGE * delta, "magic")

func create_visual_ring():
	for i in SPRITE_COUNT:
		var angle = (PI * 2 / SPRITE_COUNT) * i
		var offset = Vector2(RADIUS, 0).rotated(angle)

		var sprite = AnimatedSprite2D.new()
		sprite.sprite_frames = center_sprite.sprite_frames
		sprite.animation = center_sprite.animation
		sprite.position = offset
		sprite.play()
		add_child(sprite)
