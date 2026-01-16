extends Node2D


@export var star_count: int = 100
@export var area_width: float = 1000.0
@export var area_height: float = 800.0
@export var jitter: float = 0.4
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
		instance.position = point
		if(!star_names.is_empty()):
			instance.starName = star_names.pick_random()
			instance.frame = randi_range(0, 3)
			star_names.erase(instance.starName)
		add_child(instance)


func _on_generate_button_pressed() -> void:
	get_tree().reload_current_scene()
