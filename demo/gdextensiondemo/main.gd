extends Node2D

signal wave_completed(stats)

@onready var camera = $Camera2D
@onready var ground_layer = $TileMap/GroundLayer
@onready var obstacle_layer = $TileMap/ObstacleLayer
@onready var pathfinder = $Pathfinder
@onready var spawn_timer = $SpawnTimer
@onready var wave_timer = $WaveDelayTimer

# Referencias a UI (acceso vía ruta absoluta desde Main)
@onready var lblEstadisticas = get_node("UI/CanvasLayer/PanelStats/VBoxContainer/Label (estadisticas)")
@onready var lblGeneraciones = get_node("UI/CanvasLayer/PanelStats/VBoxContainer/Label (Generaciones transcurridas)")
@onready var lblEliminados   = get_node("UI/CanvasLayer/PanelStats/VBoxContainer/Label (Enemigos eliminados)")
@onready var lblFitness      = get_node("UI/CanvasLayer/PanelStats/VBoxContainer/Label (Fitness promedio)")
@onready var lblNiveles      = get_node("UI/CanvasLayer/PanelStats/VBoxContainer/Label (Cantidad de niveles torres)")
@onready var lblMutaciones   = get_node("UI/CanvasLayer/PanelStats/VBoxContainer/Label (Porcentaje mutaciones)")

#Escenas de enemigos
@onready var ogro_scene = preload("res://Enemigos/Ogro/Ogro.tscn")
@onready var elfo_scene = preload("res://Enemigos/Elfo/Elfo.tscn")
@onready var mercenary_scene = preload("res://Enemigos/Mercenario/Mercenario.tscn")
@onready var harpy_scene = preload("res://Enemigos/Harpia/Harpia.tscn")

#Variables para el control de oleadas
var current_wave = 0
var enemies_to_spawn = []
var enemies_alive = 0
var wave_stats = { "spawned": 0, "killed": 0, "start_time": 0 }
var wave_ended = false

func _ready():
	# Conectar señales de timers, estos se van a llamar cada cierto tiempo
	spawn_timer.timeout.connect(Callable(self, "_on_spawn_timeout"))
	wave_timer.timeout.connect(Callable(self, "_on_wave_delay_timeout"))
	
	# Inicializar Pathfinder marcando celdas
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
	# Arrancar primera oleada
	start_next_wave()

# Inicializa y arranca una nueva oleada
func start_next_wave():
	# Detener cualquier timer pendiente antes de reiniciar
	spawn_timer.stop()
	wave_timer.stop()

	current_wave += 1 #Seteo de contadores de estadisticas a 0 para cada oleada
	wave_stats["spawned"]    = 0
	wave_stats["killed"]     = 0
	wave_stats["start_time"] = Time.get_ticks_msec()
	wave_ended = false

	enemies_to_spawn = generate_wave_list(current_wave)
	lblGeneraciones.text = "Oleada: %d" % current_wave
	lblEliminados.text   = "Eliminados: 0"
	lblFitness.text      = "Fitness: -"
	lblMutaciones.text   = "Mutaciones: 0%"

	spawn_timer.start()
	print("Iniciando oleada %d" % current_wave)

# Genera la lista de escenas de enemigos para la oleada
func generate_wave_list(wave: int) -> Array:
	var listaDeEnemigosAGenerar = []
	var total = wave * 5
	
	#Cantidad de enemigos especiales segun la oleada
	var cantidad_mercenarios  = 0
	var cantidad_harpias = 0
	if wave >= 3:
		cantidad_mercenarios = int(wave/3)
	if wave >= 5:
		cantidad_harpias = int(wave/5)
	var cantidadDeEnemigosRelleno = total - cantidad_mercenarios - cantidad_harpias #lo que hace es sacar la cantidad de elfos y ogros(relleno) restando los mercenarios y harpias
	
	#Cantidad de enemigos de relleno
	for i in range(cantidadDeEnemigosRelleno):
		if i % 2 == 0:
			listaDeEnemigosAGenerar.append(ogro_scene)
		else:
			listaDeEnemigosAGenerar.append(elfo_scene)
	
	#Añadimos el resto de enemigos chetados
	#Mercenarios:
	for i in range(cantidad_mercenarios):
		listaDeEnemigosAGenerar.append(mercenary_scene)
	
	#Harpias
	for i in range(cantidad_harpias):
		listaDeEnemigosAGenerar.append(harpy_scene)
		
	#Luego podemos mezclar un poco la lista para dar sensacion de random
	listaDeEnemigosAGenerar.shuffle()
	
	return listaDeEnemigosAGenerar

# Spawn de enemigos, timers que e llaman cada cierto tiempo
func _on_spawn_timeout():
	if enemies_to_spawn.is_empty():
		# Ya generó todos; espera muertes para cerrar oleada
		return
		
	#generaciones de enemigos, ya sea si quedan por spawnear, los instancia y los añade a la escena
	var scene = enemies_to_spawn.pop_front()
	var enemy = scene.instantiate()
	enemy.position = ground_layer.map_to_local(Vector2i(0, 0))
	add_child(enemy)
	enemy.connect("died", Callable(self, "_on_enemy_died"), CONNECT_ONE_SHOT)
	wave_stats["spawned"] += 1

func _on_enemy_died(): #Esta funcion se llama por medio de la señal, cada ves que un enemigo muere.
	if wave_ended: #Si la oleada ya termino simplemente no s ehace nada.
		return
	wave_stats["killed"] += 1 #Pero si no ha terminado si toca actualizar las Stats
	lblEliminados.text = "Eliminados: %d" % wave_stats["killed"]

	# Solo terminar oleada cuando no haya más por spawnear y todos los generados estén muertos
	if enemies_to_spawn.is_empty() and wave_stats["killed"] >= wave_stats["spawned"]:
		_end_wave() #Se llama a la funcion encargada de frenar todos los timers y calcular el fitness

func _end_wave(): #Se llama cuando no quedan mas enemigos
	wave_ended = true
	# Asegurar que no quedan timers corriendo porque eso se bugueaba, iniciaba una oleada antes de que temrinara la otra
	spawn_timer.stop()
	wave_timer.stop()

	var _duration = Time.get_ticks_msec() - wave_stats["start_time"]
	var avg_fitness = compute_avg_fitness()
	lblFitness.text    = "Fitness: %.2f" % avg_fitness
	lblMutaciones.text = "Mutaciones: %d%%" % 0
	emit_signal("wave_completed", {"wave": current_wave, "stats": wave_stats})

	# Iniciar próxima oleada tras retardo en dos segundos
	wave_timer.start(2.0)
	
func _on_wave_delay_timeout():
	# Desde la funcion _end_wave cuando termina la oleada se inicia el wave_timer.start(2.0), 
	#se emite la señal, ese timeot se conecta con Callable(self, "_on_wave_delay_timeout"),llamando
	#asi esta funcion
	start_next_wave()

# Placeholder(o protopipo hueco por el momento) para cálculo de fitness promedio
func compute_avg_fitness() -> float:
	return 0.0
