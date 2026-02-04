@tool
extends Node3D

@export var star_variants_count: int = 4  # Количество вариантов звезд
@export var star_row: int = 0  # Номер строки с звездами в атласе
@export var starName := "Star":
	set(value):
		starName = value
		$StarName.text = starName
		notify_property_list_changed()

func _ready() -> void:
	add_to_group("Stars")



	
