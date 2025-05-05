extends "res://Enemigos/CualidadesBaseEnemigo.gd"

signal died

func _ready():
	health = 150
	speedOfMovement = 25
	arrowResistance = 45
	magicResistance = 1
	artilleryResistance = 45
	oroADropear = 45
	multiplicadorOro = 11
	
	super._ready() # Llama al _ready() de la clase base
	
func _process(delta):
	super._process(delta) 
	
	if path_index >= path.size():
		emit_signal("died")
