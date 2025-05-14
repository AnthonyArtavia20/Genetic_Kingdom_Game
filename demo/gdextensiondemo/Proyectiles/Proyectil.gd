extends Area2D

var velocidad = 300.0
var objetivo: Node2D = null

func _process(delta):
	if objetivo and objetivo.is_inside_tree():
		var dir = (objetivo.global_position - global_position).normalized()
		position += dir * velocidad * delta
		
		if global_position.distance_to(objetivo.global_position) < 5.0:
			objetivo.queue_free()
			queue_free()
	else:
		queue_free()
