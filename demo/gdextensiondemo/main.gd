extends Node2D

@onready var camera = $Camera2D
@onready var ground_layer = $TileMap/GroundLayer
@onready var obstacle_layer = $TileMap/ObstacleLayer
@onready var pathfinder = $Pathfinder

func _ready():
	camera.make_current()
	camera.zoom = Vector2(0.5, 0.5)
	
	print("Inicializando Pathfinder...")

	# 1. Primero marcamos TODO lo caminable
	for y in range(17):
		for x in range(41):
			var tile_pos = Vector2i(x, y)
			var tile_id = ground_layer.get_cell_source_id(tile_pos)
			if tile_id != -1:
				pathfinder.set_obstacle(tile_pos, true)  # true = caminable

	# 2. Luego marcamos TODO lo que es obstáculo (sobrescribe)
	for y in range(17):
		for x in range(41):
			var tile_pos = Vector2i(x, y)
			var tile_id = obstacle_layer.get_cell_source_id(tile_pos)
			if tile_id != -1:
				pathfinder.set_obstacle(tile_pos, false)  # false = no caminable
				print("Marcado como obstáculo:", tile_pos)
