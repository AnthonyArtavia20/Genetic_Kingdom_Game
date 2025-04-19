extends Node2D

func _ready():
	print("Probando integración de Pathfinder en C++")

	var pathfinder = Pathfinder.new()
	add_child(pathfinder)

	# Opcional: llamar métodos si están definidos y expuestos en tu clase C++
	# por ejemplo, si tienes:
	# func set_obstacle(Vector2i, bool)
	pathfinder.set_obstacle(Vector2i(5, 5), false)
	var ruta = pathfinder.get_path(Vector2i(0, 0), Vector2i(10, 10))
	print(ruta)


	print("Pathfinder añadido al árbol de nodos")
