extends "res://Enemigos/CualidadesBaseEnemigo.gd"

func _ready():
	health = 200
	speedOfMovement = 300.0
	super._ready() # Llama al _ready() de la clase base
