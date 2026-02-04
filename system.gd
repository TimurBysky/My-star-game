extends Node3D

@onready var Selected_square = $Select_square
@export var planet_scene: PackedScene
var rng = RandomNumberGenerator.new()
var planet_position = Vector3(0.5,0.0,2.0)
var planets = []

signal star_clicked(star)
signal move_star_clicked(star)
signal planet_clicked(planet)

func _ready() -> void:
	#$Planet/MouseZone.input_event.connect(on_planet_pressed)
	$Star/MouseZone.input_event.connect(on_star_pressed)
	Selected_square.scale = scale*20
	Selected_square.visible = false
	add_to_group("Stars")

	for i in randi_range(0,5):
		var instance = planet_scene.instantiate()
		planet_position += Vector3(0.0,0.0,randf_range(3.0, 4.5))
		instance.position = planet_position
		var mouse_zone = instance.get_node("MouseZone")
		mouse_zone.input_event.connect(on_planet_pressed.bind(instance))
		var random_scale = randf_range(0.8, 2.0)
		instance.scale = Vector3(random_scale, random_scale, random_scale)
		planets.append(instance)
		add_child(instance)

# Правильная сигнатура для input_event в Godot 4.x
func on_planet_pressed(camera: Camera3D, event: InputEvent, position: Vector3, normal: Vector3,\
 shape_idx: int, planet: Node3D):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			print("Планета нажата!")
			planet_clicked.emit(planet)

func on_star_pressed(camera: Camera3D, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			Selected_square.visible = true
			star_clicked.emit(self)
			print("Звезда нажата!")
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_RIGHT:
			move_star_clicked.emit(self)
			print("Звезда нажата!")
			#update_camera_position($Star)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if Selected_square.visible:
				Selected_square.visible = false

func update_camera_position(object):
	$Camera3D.target = object.position
	$Camera3D.update_camera()
