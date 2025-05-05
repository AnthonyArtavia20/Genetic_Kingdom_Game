extends "res://Enemigos/CualidadesBaseEnemigo.gd"

signal died

func _ready():
	health = 75
	speedOfMovement = 125
	arrowResistance = 20
	magicResistance = 50
	artilleryResistance = 0
	oroADropear = 25
	multiplicadorOro = 7
	
	super._ready() # Llama al _ready() de la clase base
	
func _process(delta):
	super._process(delta) 
	
	if path_index >= path.size():
		emit_signal("died")
