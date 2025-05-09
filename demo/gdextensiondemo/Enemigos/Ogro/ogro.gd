extends "res://Enemigos/CualidadesBaseEnemigo.gd"

signal died

func _ready():
	health = 100
	speedOfMovement = 50
	arrowResistance = 75
	magicResistance = 0
	artilleryResistance = 0
	oroADropear = 10
	multiplicadorOro = 5
	
	super._ready() # Llama al _ready() de la clase base
	
func _process(delta):
	super._process(delta) 
	
	if path_index >= path.size():
		emit_signal("died")
