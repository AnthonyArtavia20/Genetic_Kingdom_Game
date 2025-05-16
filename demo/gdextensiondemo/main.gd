extends Node2D

@onready var camera = $Camera2D
@onready var ground_layer = $TileMap/GroundLayer
@onready var obstacle_layer = $TileMap/ObstacleLayer
@onready var pathfinder = $Pathfinder
@onready var genetic_manager = $GeneticManager
@onready var spawn_timer = $SpawnTimer
@onready var wave_timer = $WaveDelayTimer

# Referencias a UI (acceso vía ruta absoluta desde Main)
@onready var lblEstadisticas = get_node("UI/CanvasLayer/PanelStats/VBoxContainer/Label (estadisticas)")
@onready var lblGeneraciones = get_node("UI/CanvasLayer/PanelStats/VBoxContainer/Label (Generaciones transcurridas)")
@onready var lblEliminados   = get_node("UI/CanvasLayer/PanelStats/VBoxContainer/Label (Enemigos eliminados)")
@onready var lblFitness      = get_node("UI/CanvasLayer/PanelStats/VBoxContainer/Label (Fitness promedio)")
@onready var lblNiveles      = get_node("UI/CanvasLayer/PanelStats/VBoxContainer/Label (Cantidad de niveles torres)")
@onready var lblMutaciones   = get_node("UI/CanvasLayer/PanelStats/VBoxContainer/Label (Porcentaje mutaciones)")
@onready var lblGold         = get_node("UI/CanvasLayer/PanelTowers/VBoxContainer/Label (Display_Gold)")
@onready var lblBridgeLife   = get_node("UI/CanvasLayer/PanelTowers/VBoxContainer/Label (Bridge_Life)")
@onready var lblTowersLevelOne = get_node("UI/CanvasLayer/PanelStats/VBoxContainer/TowersLevelOne")
@onready var lblTowersLevelTwo = get_node("UI/CanvasLayer/PanelStats/VBoxContainer/TowersLevelTwo")
@onready var lblTowersLevelThree = get_node("UI/CanvasLayer/PanelStats/VBoxContainer/TowersLevelThree")

#Escenas de enemigos
@onready var ogro_scene = preload("res://Enemigos/Ogro/Ogro.tscn")
@onready var elfo_scene = preload("res://Enemigos/Elfo/Elfo.tscn")
@onready var mercenary_scene = preload("res://Enemigos/Mercenario/Mercenario.tscn")
@onready var harpy_scene = preload("res://Enemigos/Harpia/Harpia.tscn")

@onready var tower_container = $TowerContainer

var buy_archer_button: Button
var buy_mage_button: Button
var buy_artillery_button: Button

var current_gold = 1200
var level_one_towers = 0
var level_two_towers = 0
var level_three_towers = 0

var selected_tower_scene: PackedScene = null
var tower_cost = 0

#Variables para el control de oleadas
var current_wave = 0
var enemies_to_spawn = []
var enemies_alive = 0
var wave_stats = { "spawned": 0, "killed": 0, "start_time": 0 }
var wave_ended = false
var next_generation = []
var dead_enemies_data = []

var bridge_life = 30

func _ready():
	randomize()
	spawn_timer.timeout.connect(Callable(self, "_on_spawn_timeout"))
	wave_timer.timeout.connect(Callable(self, "_on_wave_delay_timeout"))
	genetic_manager.connect("generation_ready", Callable(self, "_on_generation_ready"))

	var ui_panels = $UI.get_child(0)  # asumiendo que UI solo tiene uno: la escena instanciada
	buy_archer_button = ui_panels.get_node("PanelTowers/VBoxContainer/TorreContainer1/Button_Archer")
	buy_mage_button = ui_panels.get_node("PanelTowers/VBoxContainer/TorreContainer2/Button_Mage")
	buy_artillery_button = ui_panels.get_node("PanelTowers/VBoxContainer/TorreContainer3/Button_Artillery")

	buy_archer_button.pressed.connect(_on_buy_archer_pressed)
	buy_mage_button.pressed.connect(_on_buy_mage_pressed)
	buy_artillery_button.pressed.connect(_on_buy_artillery_pressed)

	print("Inicializando Pathfinder...")
	for y in range(17):
		for x in range(41):
			var tile_pos = Vector2i(x, y)
			var tile_id = ground_layer.get_cell_source_id(tile_pos)
			if tile_id != -1:
				pathfinder.set_obstacle(tile_pos, true)
	for y in range(17):
		for x in range(41):
			var tile_pos = Vector2i(x, y)
			var tile_id = obstacle_layer.get_cell_source_id(tile_pos)
			if tile_id != -1:
				pathfinder.set_obstacle(tile_pos, false)

	start_next_wave()
	
func _process(delta):
	lblGold.text = "💰 Current Gold: %.2f" % float(current_gold)
	lblBridgeLife.text = "❤️ Bridge Life: %d" % int(bridge_life)
	lblTowersLevelOne.text = "Nivel 1: %d" % int(level_one_towers)
	lblTowersLevelTwo.text = "Nivel 2: %d" % int(level_two_towers)
	lblTowersLevelThree.text = "Nivel 3: %d" % int(level_three_towers)

func start_next_wave():
	spawn_timer.stop()
	wave_timer.stop()
	current_wave += 1
	wave_stats = {
		"spawned": 0,
		"killed": 0,
		"start_time": Time.get_ticks_msec()
	}
	wave_ended = false

	lblGeneraciones.text = "Oleada: %d" % current_wave
	lblEliminados.text   = "Eliminados: 0"
	lblMutaciones.text   = "Mutaciones: 100%"

	print("🟢-> Iniciando oleada %d" % current_wave)

	if next_generation.is_empty():
		enemies_to_spawn = generate_wave_list(current_wave)
	else:
		enemies_to_spawn.clear()
		for dict in next_generation:
			var tipo = dict.get("type", "ogro")
			var enemy = null

			match tipo:
				"ogro":
					enemy = ogro_scene.instantiate()
				"elfo":
					enemy = elfo_scene.instantiate()
				"harpia":
					enemy = harpy_scene.instantiate()
				"merc":
					enemy = mercenary_scene.instantiate()
				_:
					enemy = ogro_scene.instantiate()

			enemy.health = dict.get("health", 50.0)
			enemy.speedOfMovement = dict.get("speed", 50.0)
			enemy.arrowResistance = dict.get("arrow_res", 0.0)
			enemy.magicResistance = dict.get("magic_res", 0.0)
			enemy.artilleryResistance = dict.get("artillery_res", 0.0)
			enemy.oroADropear = dict.get("gold", 10.0)
			enemy.genes = dict.duplicate(true)

			enemies_to_spawn.append(enemy)

		next_generation.clear()

	spawn_timer.start()

# Genera la lista de escenas de enemigos para la oleada
func generate_wave_list(wave: int) -> Array:
	var listaDeEnemigosAGenerar = []

	var total = wave * 5  # Cantidad total de enemigos de la oleada (crece con la oleada)

	#Cantidad de enemigos especiales segun la oleada
	var cantidad_mercenarios  = 0
	var cantidad_harpias = 0
	if wave >= 3:
		cantidad_mercenarios = int(wave / 3)
	if wave >= 5:
		cantidad_harpias = int(wave / 5)
	var cantidadDeEnemigosRelleno = total - cantidad_mercenarios - cantidad_harpias 
	# lo que hace es sacar la cantidad de elfos y ogros(relleno) restando los mercenarios y harpias
	
	#Cantidad de enemigos de relleno
	for i in range(cantidadDeEnemigosRelleno):
		if i % 2 == 0:
			listaDeEnemigosAGenerar.append(ogro_scene.instantiate())
		else:
			listaDeEnemigosAGenerar.append(elfo_scene.instantiate())
	
	#Añadimos el resto de enemigos chetados
	#Mercenarios:
	for i in range(cantidad_mercenarios):
		listaDeEnemigosAGenerar.append(mercenary_scene.instantiate())
	
	#Harpias
	for i in range(cantidad_harpias):
		listaDeEnemigosAGenerar.append(harpy_scene.instantiate())
		
	#Luego podemos mezclar un poco la lista para dar sensacion de random
	listaDeEnemigosAGenerar.shuffle()

	return listaDeEnemigosAGenerar

func _on_spawn_timeout():
	if enemies_to_spawn.is_empty():
		return
	var enemy = enemies_to_spawn.pop_front()
	enemy.position = ground_layer.map_to_local(Vector2i(0, 0))
	enemy.birth_time = Time.get_ticks_msec()
	enemy.connect("died", Callable(self, "_on_enemy_died").bind(enemy), CONNECT_ONE_SHOT)
	add_child(enemy)
	wave_stats["spawned"] += 1
	enemies_alive += 1

func _on_enemy_died(enemy):
	if wave_ended:
		return
	enemies_alive -= 1
	wave_stats["killed"] += 1
	lblEliminados.text = "Eliminados: %d" % wave_stats["killed"]

	var death_time = Time.get_ticks_msec()
	var lifetime = death_time - enemy.birth_time
	var gold = enemy.oroADropear if enemy.has_method("oroADropear") else 10
	current_gold += gold


	var original = {
		"health": enemy.health,
		"speed": enemy.speedOfMovement,
		"arrow_res": enemy.arrowResistance,
		"magic_res": enemy.magicResistance,
		"artillery_res": enemy.artilleryResistance,
		"gold": enemy.oroADropear
	}

	dead_enemies_data.append({
		"lifetime": lifetime,
		"gold": gold,
		"genes": enemy.genes
	})

	if enemies_to_spawn.is_empty() and enemies_alive <= 0:
		_end_wave()

func _end_wave():
	wave_ended = true
	spawn_timer.stop()
	wave_timer.stop()
	lblFitness.text = "Fitness: calculando..."
	lblMutaciones.text = "Mutaciones: calculando..."

	var lived_times = []
	var gold_drops = []
	var original_data = []

	print("📊 Enviando datos al GA. Enemigos registrados:", dead_enemies_data.size())
	for d in dead_enemies_data:
		lived_times.append(d["lifetime"])
		gold_drops.append(d["gold"])
		original_data.append(d["genes"])
		print("  -> tiempo:", d["lifetime"], " oro:", d["gold"])

	dead_enemies_data.clear()
	
	var wave_size = randi_range(3, 7)
	genetic_manager._on_wave_completed({
		"lived_times": lived_times,
		"gold_drops": gold_drops,
		"original_data": original_data,
		"next_wave_size": wave_size
	})

	print("⏳ Esperando generación genética para oleada %d..." % current_wave)
	wave_timer.start(2.0)

func _on_generation_ready(new_population):
	print("Se recibió nueva generación con %d individuos" % new_population.size())

	if new_population.is_empty():
		print("a nueva generación está vacía. No se puede continuar.")
		return

	next_generation = new_population

	var total_fitness = 0.0
	var tau_max = 30000.0
	var g_max = 50.0

	for d in new_population:
		var t = float(d.get("health", 0))  # get() evita errores si falta la clave
		var g = float(d.get("gold", 0))
		var fitness = 0.5 * ((tau_max - t) / tau_max) + 0.5 * (g / g_max)
		total_fitness += fitness
		print("  ↪︎ Individuo - salud:%.2f oro:%.2f fitness:%.10f" % [t, g, fitness])
		print("↪︎ Tipo generado: ", d.get("type"), " | oro: ", d.get("gold"))


	var avg_fitness = total_fitness / new_population.size()
	lblFitness.text = "Fitness: %.3f" % avg_fitness
	lblMutaciones.text = "Mutaciones: 50%"
	
	# Espera 0.1 segundos antes de continuar con la siguiente oleada
	await get_tree().create_timer(0.1).timeout
	start_next_wave()
	
func _on_buy_archer_pressed():
	select_tower_to_place("res://Torres/Archer.tscn", 150)

func _on_buy_mage_pressed():
	select_tower_to_place("res://Torres/Mage.tscn", 250)

func _on_buy_artillery_pressed():
	select_tower_to_place("res://Torres/Artillery.tscn", 450)
	
func select_tower_to_place(scene_path: String, cost: int):
	selected_tower_scene = load(scene_path)
	tower_cost = cost

func _unhandled_input(event):
	if selected_tower_scene and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var click_pos = get_global_mouse_position()

		var cell = obstacle_layer.local_to_map(obstacle_layer.to_local(click_pos))
		var tile_id = obstacle_layer.get_cell_source_id(cell)

		print("Celda clickeada:", cell, "ID tile:", tile_id)

		if tile_id == 1:
			var world_pos = obstacle_layer.to_global(obstacle_layer.map_to_local(cell))
			
			# Compensación manual para corregir desfase de torre
			world_pos -= Vector2(0, 0)

			for torre in tower_container.get_children():
				if torre.position.distance_to(world_pos) < 1:
					print("⚠️ Ya hay una torre aquí.")
					return

			if current_gold >= tower_cost:
				var tower = selected_tower_scene.instantiate()
				tower.position = world_pos
				tower_container.add_child(tower)
				current_gold -= tower_cost
				selected_tower_scene = null
				print("✅ Torre colocada correctamente en posición exacta:", world_pos)
				level_one_towers+=1 # Puesto que siempre que se coloca una torre, esta es de nivel 1.
			else:
				print("❌ No tienes suficiente oro.")
		else:
			print("⛔ No se puede construir aquí. Celda inválida.")
			
func bridge_hit():
	bridge_life -= 1
	if bridge_life == 0:
		get_tree().paused = true
