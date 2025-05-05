extends "res://Enemigos/CualidadesBaseEnemigo.gd"

signal died

func _ready():
	health = 50
	speedOfMovement = 40
	arrowResistance = 2
	magicResistance = 2
	artilleryResistance = 100
	oroADropear = 30
	multiplicadorOro = 9
	
	super._ready() # Llama al _ready() de la clase base
	
func _process(delta):
	super._process(delta) 
	
	if path_index >= path.size():
		emit_signal("died")
