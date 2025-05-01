#Atributos comunes de los enemigos, la idea es que cada
#enemigo tenga estas caracteristicas como base

extends CharacterBody2D

var path : PackedVector2Array = []
var path_index = 0
var speedOfMovement = 100.0
var health = 100 #Vida general para todos, cambiar esto.

func _ready():
  #Inicializar el pathfinding de forma general para cada enemigo.
  var pathfinder = get_tree().root.get_node("Main/Pathfinder") as Pathfinder

  var start = Vector2i(0,0) #Punto de inicio donde aparecerán los enemigos
  var endingPoint = Vector2i(39,16) #Punto final o meta.

  path = pathfinder.get_path(start, endingPoint) #Calcula la ruta con A*
  if path.size() > 0: #verifica si se llega al final.
   var tilemap = get_parent().get_node("TileMap/GroundLayer")
   position = tilemap.to_global(tilemap.map_to_local(path[0]))

func _process(delta): #Movimiento perpetuo de los enemigos
  #Movimiento estandar para cada tipo de enemigo:
  if path_index >= path.size(): #Solo si se llega a que la última celda sea literalmente la meta, entonces quitmaos de la lista a ese enemigo.
   queue_free() #Libera de la lista a ese enemigo.
   return

  var tilemap = get_parent().get_node("TileMap/GroundLayer") #Obtiene la referencia al nodo GroundLayer del TileMap, donde se mueven los bichos.
  var target_world_pos = tilemap.to_global(tilemap.map_to_local(path[path_index])) #Obtenemos las posiciones de la celda actual en la ruta en coordenadas (x,y), luego se convierten a coordendas locales del tilemap y luego se pasa a Pixeles
  var direction = (target_world_pos - position).normalized() #Se calcula un vector apuntando desde la posición actual hasta la posición objetivo, luego se convierte a un vector unitario con .normalized(), dando una dirección pero sin magnitud. MOviendo el bicho a velocidad ocnstante.
  position += direction * speedOfMovement * delta #Actualiza la posición del enemigo sumando un desplazamiento. Delta es el tiempo trancurrido desde le último frame, lo da godot.

  if position.distance_to(target_world_pos) < 4:
   path_index += 1

func take_damage(amount):
  #Método para quitar daño, lo tendrán todos los enemigos.
  health -= amount
  if health <= 0:
   queue_free()
