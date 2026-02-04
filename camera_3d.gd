extends Camera3D

@export var zoom_speed: float = 5.0
@export var min_height: float = 15.0
@export var max_height: float = 150.0
@export var zoom_smoothness: float = 8.0  # Скорость интерполяции (больше = быстрее)
@export var move_speed: float = 1.0
@export var edge_threshold: float = 50.0  # Пиксели от края
@export var height_speed_multiplier: float = 0.1
@export var min_speed: float = 5.0
@export var max_speed: float = 50.0

var is_panning: bool = false
var target_height: float = 50.0  # Целевая высота
var current_height: float = 50.0  # Текущая высота (плавно догоняет целевую)
var last_mouse_pos: Vector2
var pan_speed: float = 0.003
var fixed_rotation: Vector3 = Vector3(-90, 0, 0)  # Фиксированный угол в градусах

func _ready():
	target_height = position.y
	current_height = position.y

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			# Меняем целевую высоту
			target_height = clamp(target_height - zoom_speed, min_height, max_height)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_height = clamp(target_height + zoom_speed, min_height, max_height)	
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			is_panning = event.pressed
			if event.pressed:
				last_mouse_pos = event.position
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			else:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Панорамирование при движении мыши
	if event is InputEventMouseMotion and is_panning:
		var delta = event.relative
		pan_camera(delta)
		last_mouse_pos = event.position
			

func pan_camera(mouse_delta: Vector2):
	# Вычисляем вектора направления камеры
	var forward = global_transform.basis.z.normalized()  # Взгляд камеры
	var right = global_transform.basis.x.normalized()     # Вправо от камеры
	
	# Для панорамирования в плоскости земли, используем горизонтальные вектора
	var horizontal_right = Vector3(right.x, 0, right.z).normalized()
	var horizontal_forward = Vector3(forward.x, 0, forward.z).normalized()
	
	# Двигаем камеру
	position -= horizontal_right * mouse_delta.x * pan_speed * current_height
	position += horizontal_forward * mouse_delta.y * pan_speed * current_height
	
	# Сохраняем фиксированный угол поворота
	rotation_degrees = fixed_rotation


func _process(delta):
	var viewport = get_viewport()
	var mouse_pos = viewport.get_mouse_position()
	var viewport_size = viewport.get_visible_rect().size
	
	var move_vector = Vector3.ZERO
	# Плавная интерполяция текущей высоты к целевой
	if abs(current_height - target_height) > 0.01:
		current_height = lerp(current_height, target_height, zoom_smoothness * delta)
		
		# Для камеры с фиксированным углом нужно двигать и по горизонтали
		var height_change = current_height - position.y
		var forward = -global_transform.basis.z
		
		# Вычисляем горизонтальное смещение для сохранения угла
		var angle_rad = deg_to_rad(-rotation_degrees.x)  # Ваш угол наклона
		var horizontal_shift = height_change / tan(angle_rad)
		
		# Применяем изменения
		position.y = current_height
		position += forward * horizontal_shift
		
	if mouse_pos.x < edge_threshold:  # Левый край
		move_vector.x -= move_speed
	if mouse_pos.x > viewport_size.x - edge_threshold:  # Правый край
		move_vector.x += move_speed 
	if mouse_pos.y < edge_threshold:  # Верхний край
		move_vector.y -= move_speed  # Вперед (помним про -Z)
	if mouse_pos.y > viewport_size.y - edge_threshold:  # Нижний край
		move_vector.y += move_speed  # Назад
	
	# Двигаем камеру
	if move_vector.length() > 0:
		move_vector = move_vector.normalized()
		
		var current_speed = move_speed * (1.0 + position.y * height_speed_multiplier)
		current_speed = clamp(move_speed, min_speed, max_speed)
		# УМНОЖАЕМ ЗДЕСЬ, после нормализации
		move_vector *= move_speed * current_height * delta  # Например: 10 * 50 * 0.016 = 8
		
		var forward = -global_transform.basis.y  # Z, а не Y!
		var right = global_transform.basis.x
		
		position += (right * move_vector.x + forward * move_vector.y)
		
func _on_star_clicked(star_node: Node3D):
	print("Клик по звезде:", star_node.name)
	print("Позиция звезды:", star_node.global_position)
	
	# Перемещаем камеру к звезде
	move_to_star(star_node)

func move_to_star(star: Node3D):
	# Плавное перемещение камеры к звезде
	var target_pos = star.global_position + Vector3(0, 15, 0)
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, 1.0)
	
	# Обновляем высоту (берем только Y координату)
	current_height = target_pos.y
	target_height = current_height  # Если используете target_height для зума
	#tween.tween_property(self, "rotation_degrees",
		#Vector3(-45, 0, 0), 0.5)
