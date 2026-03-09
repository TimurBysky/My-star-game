extends Node

var queue = []
var available_turns = {}

signal send_request

func _ready() -> void:
	send_request.connect(add_to_queue)
	pass
	
func add_to_queue(object) -> void:
	if (!available_turns.has(str(object))):
		available_turns[str(object)] = object.speed
	
	if (available_turns[str(object)] <= 0):
		queue.append(str(object))
		
	move_queue(object)
		
func move_queue(object):
	if (available_turns[str(object)] >= 1):
		emit_signal(object.move)
		available_turns[str(object)] -= 1
