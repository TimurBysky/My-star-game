extends Node

var queue = {}
var object_speed = {}
var available_turns = {}

func _ready() -> void:
	pass
	
func add_to_queue(object, target) -> void:
	if (!available_turns.has(str(object))):
		available_turns[str(object)] = object.speed
		object_speed[str(object)] = object.speed
	
	if (available_turns[str(object)] <= 0):
		if(!queue.has(str(object))):
			queue[str(object)] = target
		return
	
	#emit_signal(object.move)
	print("Move!" + str(available_turns[str(object)]))
	available_turns[str(object)] -= 1
	
	#if()
		

func move_queue():
	for object in queue:
			available_turns[object] = object_speed[object]
			while(available_turns[object] <= 0): 
				print("Move at next turn!" + str(available_turns[str(object)]))
				available_turns[str(object)] -= 1
