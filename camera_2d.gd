# CameraController.gd
extends Camera2D

var zoom_speed = 0.1
var min_zoom = 0.3
var max_zoom = 2.0
var drag_speed = 500

func _input(event):
	# Приближение/отдаление колесиком мыши
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom *= (1 - zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom *= (1 + zoom_speed)
		
		zoom = clamp(zoom, Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
	
	# Перетаскивание правой кнопкой мыши
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		position -= event.relative/zoom
