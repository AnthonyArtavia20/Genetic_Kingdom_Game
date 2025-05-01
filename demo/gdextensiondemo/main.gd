extends Node2D

@onready var camera = $Camera2D
@onready var ground_layer = $TileMap/GroundLayer
@onready var obstacle_layer = $TileMap/ObstacleLayer
@onready var pathfinder = $Pathfinder
@onready var enemy_scene = preload("res://Enemigos/Ogro/Ogro.tscn")
@onready var spawn_timer = $SpawnTimer

func _ready():

	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

	print("Inicializando Pathfinder...")

	# 1. Primero marcamos TODO lo caminable
	for y in range(17):
		for x in range(41):
			var tile_pos = Vector2i(x, y)
			var tile_id = ground_layer.get_cell_source_id(tile_pos)
			if tile_id != -1:
				pathfinder.set_obstacle(tile_pos, true)  # true = caminable
				print("Marcado como caminable:", tile_pos)

	# 2. Luego marcamos TODO lo que es obstáculo (sobrescribe)
	for y in range(17):
		for x in range(41):
			var tile_pos = Vector2i(x, y)
			var tile_id = obstacle_layer.get_cell_source_id(tile_pos)
			if tile_id != -1:
				pathfinder.set_obstacle(tile_pos, false)  # false = no caminable
				print("Marcado como obstáculo:", tile_pos)

func _on_spawn_timer_timeout():
	var enemy = enemy_scene.instantiate()
	add_child(enemy)
