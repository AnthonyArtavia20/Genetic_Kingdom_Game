extends Node2D

@onready var camera = $Camera2D
@onready var ground_layer = $TileMap/GroundLayer
@onready var obstacle_layer = $TileMap/ObstacleLayer
@onready var pathfinder = $Pathfinder

@onready var spawn_timer = $SpawnTimer
@onready var wave_timer = $WaveDelayTimer

@onready var ogro_scene = preload("res://Enemigos/Ogro/Ogro.tscn")
@onready var elfo_scene = preload("res://Enemigos/Elfo/Elfo.tscn")

var current_wave = 0
var enemies_to_spawn = []
var enemies_alive = 0

func _ready():

	spawn_timer.timeout.connect(_on_SpawnTimer_timeout)
	wave_timer.timeout.connect(_on_WaveDelayTimer_timeout)
	

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
				
	start_next_wave()

func start_next_wave():
	current_wave += 1
	print("Inciando oleada %d" % current_wave)
	
	match current_wave:
		1:
			var ogros = []
			for i in range(5 * current_wave):
				ogros.append("ogro")
			enemies_to_spawn = ogros
		2:
			var ogros = []
			for i in range(10 * current_wave):
				ogros.append("ogro")
			var elfos = []
			for i in range(5 * current_wave):
				elfos.append("elfo")
			enemies_to_spawn = ogros + elfos
		_:
			var ogros = []
			for i in range(5 * current_wave):
				ogros.append("ogro")
			var elfos = []
			for i in range(2 * current_wave):
				elfos.append("elfo")
			enemies_to_spawn = ogros + elfos
	
	enemies_alive = enemies_to_spawn.size()
	spawn_timer.start()
	
func _on_SpawnTimer_timeout():
	if enemies_to_spawn.size() == 0:
		spawn_timer.stop()
		return
		
	var type = enemies_to_spawn.pop_front()
	var enemy
	
	match type:
		"ogro":
			enemy = ogro_scene.instantiate()
		"elfo":
			enemy = elfo_scene.instantiate()
			
	if enemy:
		enemy.position = ground_layer.map_to_local(Vector2i(0,0))
		add_child(enemy)
		
func _on_enemy_died():
	enemies_alive -= 1
	if enemies_alive <= 0:
		print("Todos los enemigos derrotados.")
		wave_timer.start(10)
			
func _on_WaveDelayTimer_timeout():
	start_next_wave()
