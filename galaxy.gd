extends Node3D

@onready var camera3D = $Camera3D

@export var star_count: int = 100
@export var area_width: float = 400.0
@export var area_depth: float = 200.0
@export var area_height: float = 0.0 
@export var jitter: float = 5.7
@export var min_distance: float = 1.0
@export var point_scene: PackedScene
@export var spaceship: PackedScene
@onready var galaxyGeneration = GalaxyGeneration3D.new()

var selected_star_system: Node3D
var selected_spaceship: Node3D
var target_star: Node3D

var star_names = ["Sun", "Sirius", "Gamma", "Alpha", "Beta", "Delta", "Betelgeise", "Aldebaraan", \
"Tetta", "Omega","Prime","Lamda","Mega","Epsilon","Psi","Dzeta","Yota","Kappa", "Ksi", "Omicron", "Sigma"]

var star_types = \
{
	"red_dwarf" :
	{
		"chance" : 55,
		"color" : Color.RED,
		"size_min" : 0.6,
		"size_max" : 1.0 
	},
	"red_gigant":
	{
		"chance" : 15,
		"color" : Color.RED,
		"size_min" : 1.5,
		"size_max" : 2.0 
	},
	"blue_gigant" : 
	{
		"chance" : 10,
		"color" : Color.DEEP_SKY_BLUE,
		"size_min" : 1.5,
		"size_max" : 2.5 
	},
	"yellow_dwarf":
	{
		"chance" : 25,
		"color" : Color.YELLOW,
		"size_min" : 0.8,
		"size_max" : 1.2 
	},
	"white_dwarf":
	{
		"chance" : 5,
		"color" : Color.WHITE,
		"size_min" : 0.1,
		"size_max" : 0.3 
	},
	"black_hole":
	{
		"chance" : 1,
		"color" : Color.BLACK,
		"size_min" : 0.8,
		"size_max" : 1.5 
	}
	
}

func _ready():
	connect_ui_signals()
	spawn_points()

func spawn_points():
	var points = galaxyGeneration.generate_jittered_points_3d(star_count, area_width, \
	 area_depth, area_height ,jitter , min_distance)

	
	for point in points:
		spawn_star(point)

func spawn_star(star_position: Vector3):
	#var available_star_names = star_names.duplicate()
	var instance = point_scene.instantiate()
	var star = instance.get_node("Star")
	var scale_multipler: float
	instance.position = star_position
	instance.star_clicked.connect(camera3D._on_star_clicked)
	instance.star_clicked.connect(on_star_clicked)
	instance.move_star_clicked.connect(on_star_move_clicked)
	var star_type = get_random_star_with_chance()
	star.modulate = star_types[star_type]["color"]
	scale_multipler = randf_range(star_types[star_type]["size_min"], star_types[star_type]["size_max"])
	star.scale = Vector3(scale_multipler, scale_multipler, scale_multipler)
	add_child(instance)
	
func spawn_spaceship():
	var instance = spaceship.instantiate()
	instance.parent_star = selected_star_system
	instance.on_space_ship_clicked.connect(on_spaceship_clicked)
	add_child(instance)
	
func connect_ui_signals():	
	var deviation_text = $UI_Layer/UI/MarginContainer/VBoxContainer/Deviation_text
	var deviation_slider = $UI_Layer/UI/MarginContainer/VBoxContainer/HSlider3
	var amount_of_stars_slider = $UI_Layer/UI/MarginContainer/VBoxContainer/HSlider2
	var amount_of_stars_label = $UI_Layer/UI/MarginContainer/VBoxContainer/Amount_of_stars

	
	amount_of_stars_slider.value_changed.connect(func(value: float):
		@warning_ignore("narrowing_conversion")
		star_count = value
		amount_of_stars_label.text = "Кол-во звёзд: " + str(star_count)
		)
	
	deviation_slider.value_changed.connect(func(value: float):
		jitter = value
		deviation_text.text = "Отклонение: " + str(jitter)
		)
		


func get_random_star_with_chance() -> String:
	var found_star_type = {}
	var accumulated = 0
	var summary_chance = 0
	
	for star_name in star_types:
		summary_chance += star_types[star_name]["chance"]
		
	var random_value = (randi() % summary_chance)
	
	for star_name in star_types:
		var chance = star_types[star_name]["chance"]
		if(random_value < accumulated + chance):
			found_star_type = star_name
			break
		accumulated += chance
		

	return found_star_type
	
func clear_all():
	for star in get_tree().get_nodes_in_group("Stars"):
		star.remove_from_group("Stars")
		star.queue_free()
		

func _input(event):
	# Одиночные нажатия (один раз при нажатии)
	if event is InputEventKey:
		if event.pressed:  # Клавиша нажата
			match event.keycode:
				KEY_S:
					spawn_star(get_mouse_ground_position())
				KEY_C:
					spawn_spaceship()

func get_mouse_ground_position(height: float = 0.0) -> Vector3:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = $Camera3D.project_ray_origin(mouse_pos)
	var ray_dir = $Camera3D.project_ray_normal(mouse_pos)
	
	if ray_dir.y != 0:
		var distance = (height - ray_origin.y) / ray_dir.y
		return ray_origin + ray_dir * distance
	return Vector3.ZERO

func on_star_clicked(star: Node3D):
	selected_star_system = star

func on_star_move_clicked(star: Node3D):
	target_star = star
	if selected_spaceship != null:
		selected_spaceship.move_to_(target_star)
	
func on_spaceship_clicked(spaceship: Node3D):
	selected_spaceship = spaceship

func _on_generate_button_pressed() -> void:
	clear_all() #Очищаем всё
	spawn_points()#Создаём заново

func _on_clear_button_pressed() -> void:
	clear_all()
	
	
