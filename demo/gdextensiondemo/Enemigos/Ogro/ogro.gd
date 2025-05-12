extends "res://Enemigos/CualidadesBaseEnemigo.gd"
#Ogro
func _ready():
	health = 100
	speedOfMovement = 200
	arrowResistance = 75
	magicResistance = 0
	artilleryResistance = 0
	oroADropear = 10
	multiplicadorOro = 5

	super._ready() # Llama al _ready() de la clase base

func _process(delta):
	super._process(delta)
