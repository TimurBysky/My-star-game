extends Node2D


@export var star_count: int = 100
@export var area_width: float = 1000.0
@export var area_height: float = 800.0
@export var jitter: float = 0.4
@export var is_black_hole_chance = 5.0
@export var point_scene: PackedScene
@onready var galaxyGeneration = GalaxyGeneration.new()

var star_names = ["Sun", "Sirius", "Gamma", "Alpha", "Beta", "Delta", "Betelgeise", "Aldebaraan", \
"Tetta", "Omega","Prime","Lamda","Mega","Epsilon","Psi","Dzeta","Yota","Kappa", "Ksi", "Omicron", "Sigma"]

var star_color = \
{
	"red_star" :
	{
		"chance" : 65,
		"frame" : 0
	},
	"blue_star" : 
	{
		"chance" : 5,
		"frame" : 1
	},
	"yellow_star":
	{
		"chance" : 25,
		"frame" : 2
	},
	"purple_star":
	{
		"chance" : 3,
		"frame" : 3
	}
}

var black_hole = \
{
	"black_hole": 4 
}

func _ready():
	connect_signals()
	spawn_points()

func spawn_points():
	var points = galaxyGeneration.generate_jittered_points(star_count, area_width, area_height, jitter)
	var available_star_names = star_names.duplicate()
	
	for point in points:
		var instance = point_scene.instantiate()
		var star = instance.get_node("StarImage")
		var is_black_hole: bool = (randi() % 100) < is_black_hole_chance
		var scale_multipler: float
		instance.position = point
		if(is_black_hole):
			instance.starName = "Black Hole"
			star.frame = black_hole.get("black_hole") 
			scale_multipler = randf_range(0.25, 1.0)
		if(!available_star_names.is_empty() and !is_black_hole):
			instance.starName = available_star_names.pick_random()
			available_star_names.erase(instance.starName)
		if(!is_black_hole):
			star.frame = randi() % star_color.size()
			scale_multipler = randf_range(0.5, 2.0)
		star.scale = Vector2(scale_multipler, scale_multipler)
		add_child(instance)


func _on_generate_button_pressed() -> void:
	for star in get_tree().get_nodes_in_group("Stars"): #Очищяем
		star.queue_free()
	spawn_points()#Создаём заново

func connect_signals():
	var black_hole_slider = $UI_Layer/UI/MarginContainer/VBoxContainer/HSlider
	var black_hole_label = $UI_Layer/UI/MarginContainer/VBoxContainer/Black_hole_text
	
	black_hole_slider.value_changed.connect(func(value: float):
		is_black_hole_chance = value
		black_hole_label.text = "Шанс появления чёрной дыры: " + str(is_black_hole_chance)
	)
	
	var amount_of_stars_slider = $UI_Layer/UI/MarginContainer/VBoxContainer/HSlider2
	var amount_of_stars_label = $UI_Layer/UI/MarginContainer/VBoxContainer/Amount_of_stars

	amount_of_stars_slider.value_changed.connect(func(value: float):
		star_count = value
		amount_of_stars_label.text = "Кол-во звёзд: " + str(star_count)
		)

	var deviation_text = $UI_Layer/UI/MarginContainer/VBoxContainer/Deviation_text
	var deviation_slider = $UI_Layer/UI/MarginContainer/VBoxContainer/HSlider3
	
	deviation_slider.value_changed.connect(func(value: float):
		jitter = value
		deviation_text.text = "Отклонение: " + str(jitter)
		)

func get_random_star_with_chance():
	var 
