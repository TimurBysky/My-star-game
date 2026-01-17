extends Node2D


@export var star_count: int = 100
@export var area_width: float = 1000.0
@export var area_height: float = 800.0
@export var jitter: float = 0.4
@export var is_black_hole_chance: int = 40
@export var point_scene: PackedScene
@onready var galaxyGeneration = GalaxyGeneration.new()

var star_names = ["Sun", "Sirius", "Gamma", "Alpha", "Beta", "Delta", "Betelgeise", "Aldebaraan", \
"Tetta", "Omega","Prime","Lamda","Mega","Epsilon","Psi","Dzeta","Yota","Kappa", "Ksi", "Omicron", "Sigma"]

func _ready():
	spawn_points()

func spawn_points():
	var points = galaxyGeneration.generate_jittered_points(star_count, area_width, area_height, jitter)
	
	for point in points:
		var instance = point_scene.instantiate()
		var star = instance.get_node("StarImage")
		var is_black_hole: bool = (randi_range(1, 40) == 20)
		var scale_multipler: float
		instance.position = point
		if(is_black_hole):
			instance.starName = "Black Hole"
			star.frame = 4 
			scale_multipler = randf_range(0.25, 1.0)
		if(!star_names.is_empty() and !is_black_hole):
			instance.starName = star_names.pick_random()
			star_names.erase(instance.starName)
		if(!is_black_hole):		
			star.frame = randi_range(0, 3)
			scale_multipler = randf_range(0.5, 2.0)
		star.scale = Vector2(scale_multipler, scale_multipler)
		add_child(instance)


func _on_generate_button_pressed() -> void:
	get_tree().reload_current_scene()
