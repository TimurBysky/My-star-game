extends Node2D

var warpNetwork: WarpNetwork

func _ready() -> void:
	warpNetwork = WarpNetwork.new()
	add_child(warpNetwork)
	warpNetwork.generate_nearest_connections($Warps)


func _on_generate_button_pressed() -> void:
	warpNetwork.generate_nearest_connections($Warps)
