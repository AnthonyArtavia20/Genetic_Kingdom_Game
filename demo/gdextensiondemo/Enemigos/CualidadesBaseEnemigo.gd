#Atributos comunes de los enemigos, la idea es que cada
#enemigo tenga estas caracteristicas como base

extends CharacterBody2D

signal died  # Señal para notificar cuando el enemigo muere (algoritmo genético)

var path : PackedVector2Array = []
var path_index = 0
var genes : Dictionary = {}

var health = 100 #Vida general para todos, cambiar esto.
var speedOfMovement = 100
#Como base todos los enemigos tendran 100% de resistencia a todo, ya luego cada uno luego le
# hace poliformismo a estos atributos.
var arrowResistance = 100
var magicResistance = 100
var artilleryResistance = 100
var oroADropear = 100 #Cantidad de oro que va a droppear cada enemigo
var multiplicadorOro = 1

# Variables para algoritmo genético
var birth_time = 0  # Tiempo en que nació (para calcular cuánto sobrevivió)

func _ready():
  #Inicializar el pathfinding de forma general para cada enemigo.
	var pathfinder = get_tree().root.get_node("Main/Pathfinder") as Pathfinder

	var start = Vector2i(0,0) #Punto de inicio donde aparecerán los enemigos
	var endingPoint = Vector2i(39,16) #Punto final o meta.

	path = pathfinder.get_path(start, endingPoint) #Calcula la ruta con A*
	if path.size() > 0: #verifica si se llega al final.
		var tilemap = get_parent().get_node("TileMap/GroundLayer")
		position = tilemap.to_global(tilemap.map_to_local(path[0]))
		

  # Guardar el tiempo de nacimiento para fitness
	birth_time = Time.get_ticks_msec()

func _process(delta): #Movimiento perpetuo de los enemigos
	#Movimiento estandar para cada tipo de enemigo:
	if path_index >= path.size(): #Solo si se llega a que la última celda sea literalmente la meta, entonces quitamos de la lista a ese enemigo.
		get_tree().root.get_node("Main").bridge_hit()
		emit_signal("died")  # Notifica a main.gd que este enemigo "murió" al llegar al final
		queue_free() #Libera de la lista a ese enemigo.
		return

	var tilemap = get_parent().get_node("TileMap/GroundLayer") #Obtiene la referencia al nodo GroundLayer del TileMap, donde se mueven los bichos.
	var target_world_pos = tilemap.to_global(tilemap.map_to_local(path[path_index])) #Obtenemos las posiciones de la celda actual en la ruta en coordenadas (x,y), luego se convierten a coordendas locales del tilemap y luego se pasa a Pixeles
	var direction = (target_world_pos - position).normalized() #Se calcula un vector apuntando desde la posición actual hasta la posición objetivo, luego se convierte a un vector unitario con .normalized(), dando una dirección pero sin magnitud. MOviendo el bicho a velocidad constante.
	position += direction * speedOfMovement * delta #Actualiza la posición del enemigo sumando un desplazamiento. Delta es el tiempo transcurrido desde el último frame, lo da godot.

	if position.distance_to(target_world_pos) < 4:
		path_index += 1

func take_damage(amount: float, damage_type: String):
	var resistance = 0.0
	
	match damage_type:
		"arrow":
			resistance = arrowResistance
		"magic":
			resistance = magicResistance
		"artillery":
			resistance = artilleryResistance
		_:
			print("⚠️ Tipo de daño desconocido:", damage_type)

	# Aplica el daño considerando la resistencia. Ej: resistencia 30 ⇒ se recibe 70%
	var final_damage = amount * (1.0 - resistance / 100.0)
	health -= final_damage

	# print("💢 Recibido:", final_damage, "de", amount, "por", damage_type, "| HP restante:", health)

	if health <= 0:
		emit_signal("died")
		queue_free()

func damage_bridge():
	return 1
