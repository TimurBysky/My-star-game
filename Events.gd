extends Node

var queue = []
var available_turns = {}

func _ready() -> void:
	pass
	
func add_to_queue(object) -> void:
	if (!available_turns.has(str(object))):
		available_turns[str(object)] = object.speed
	
	if (available_turns[str(object)] <= 0):
		queue.append(str(object))
		

func move_queue():
	for object in queue:
		if (available_turns[str(object)] >= 1):
			emit_signal(object.move)
			available_turns[str(object)] -= 1
