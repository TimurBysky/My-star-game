extends Node3D

@onready var Selected_square = $Select_square
@onready var model = $fighter2
@onready var name_and_stats = $Name

var parent_star: Node3D
var move_to_star = false
var target_star: Node3D
var selected = false
var standart_oreintation = Vector3(0, deg_to_rad(90), 0)

var spaceship_type = "Корабль"
var speed = 2

signal on_space_ship_clicked(spaceship)

func _ready() -> void:
	$MouseZone.input_event.connect(on_starship_pressed)
	position =  parent_star.position + Vector3(5, 2, 1)
	rotation = standart_oreintation
	name_and_stats.text = (str(spaceship_type) + "\n" + "Скорость: " + str(speed))
	

func move_to_(star: Node3D):
	if star != parent_star:
		if selected:
					# Запоминаем текущий поворот
			var start_rot = rotation
			
			# Вычисляем целевой поворот (смотрим на звезду)
			look_at(star.position, Vector3.UP)
			var target_rot = rotation
			
			# Возвращаем начальный поворот
			rotation = start_rot
			
			# Анимация через tween
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_BACK)
			tween.set_ease(Tween.EASE_OUT)
			
			tween.tween_property(model, "rotation", target_rot, 1.5)
			
			# Колбэк по завершении
			tween.finished.connect(func():
				print("Корабль развернулся к звезде!")
				# Можно начать движение к звезде
				target_star = star
				move_to_star = true
			)

func _process(delta: float) -> void:
	if move_to_star and is_instance_valid(target_star):
		var target_pos = target_star.global_position + Vector3(5, 2, 1)
		position = position.lerp(target_pos, 5.0 * delta)
		
		# Автоматически сбрасываем при достижении
		if position.distance_to(target_pos) < 1.0:
			parent_star = target_star
			target_star = null
			move_to_star = false
			
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_BACK)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(model, "rotation", standart_oreintation, 1.0)

func on_starship_pressed(camera: Camera3D, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			Selected_square.visible = true
			selected = true
			on_space_ship_clicked.emit(self)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if Selected_square.visible:
				selected = false
				Selected_square.visible = false
