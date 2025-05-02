extends "res://Enemigos/CualidadesBaseEnemigo.gd"

signal died

func _ready():
	health = 200
	speedOfMovement = 300.0
	super._ready() # Llama al _ready() de la clase base
	
func _process(delta):
	super._process(delta) 
	
	if path_index >= path.size():
		emit_signal("died")
