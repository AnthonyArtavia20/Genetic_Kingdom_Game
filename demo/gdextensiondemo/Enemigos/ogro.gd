extends CharacterBody2D
var path : PackedVector2Array = []
var path_index = 0
var speed = 100.0

func _ready():
	var pathfinder = get_tree().root.get_node("Main/Pathfinder") as Pathfinder
	var start = Vector2i(0, 0)
	var goal = Vector2i(39, 16)
	path = pathfinder.get_path(start, goal)
	if path.size() > 0:
		# Convierte de celdas (tilemap) a coordenadas del mundo:
		var tilemap = get_parent().get_node("TileMap/GroundLayer")
		# 👇 ¡Aquí el fix importante!
		position = tilemap.to_global(tilemap.map_to_local(path[0]))

func _process(delta):
	if path_index >= path.size():
		queue_free()
		return

	var tilemap = get_parent().get_node("TileMap/GroundLayer")
	var target_world_pos = tilemap.to_global(tilemap.map_to_local(path[path_index]))
	var direction = (target_world_pos - position).normalized()
	position += direction * speed * delta

	if position.distance_to(target_world_pos) < 4:
		path_index += 1
