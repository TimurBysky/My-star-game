class_name GalaxyGeneration
extends Node

var points = []

func generate_jittered_points(N: int, width: float, height: float, jitter_strength: float = 0.5) -> Array[Vector2]:

	var points: Array[Vector2] = []
	# 1. Рассчитываем размер сетки
	var cols: int = ceili(sqrt(N * width / height))
	var rows: int = ceili(sqrt(N * height / width))
	var have_neighbor: bool
	
	# Корректируем, если сетка слишком маленькая
	while cols * rows < N:
		cols += 1
		rows += 1
	
	# 2. Размеры ячейки
	var cell_width: float = width / cols
	var cell_height: float = height / rows
	
	# 3. Максимальное смещение (50% ячейки для jitter_strength=1.0)
	var max_jitter_x: float = cell_width * jitter_strength * 0.5
	var max_jitter_y: float = cell_height * jitter_strength * 0.5
	
	# 4. Генератор случайных чисел
	var rng = RandomNumberGenerator.new()
	
	# 5. Заполняем сетку
	for row in range(rows):
		for col in range(cols):
			var attempts = 0
			var max_attempts = 10  # Чтобы не зациклиться
			var point_found = false
			
			while not point_found and attempts < max_attempts:
				attempts += 1
				
				# Центр ячейки
				var center_x: float = (col + 0.5) * cell_width
				var center_y: float = (row + 0.5) * cell_height
				
				# Случайное смещение
				var offset_x: float = rng.randf_range(-max_jitter_x, max_jitter_x)
				var offset_y: float = rng.randf_range(-max_jitter_y, max_jitter_y)
				
				# Финальная точка
				var x: float = clampf(center_x + offset_x, 0.0, width)
				var y: float = clampf(center_y + offset_y, 0.0, height)
				var candidate_point = Vector2(x, y)
				
				# Проверяем расстояние до других звёзд
				var too_close = false
				for existing_point in points:
					if candidate_point.distance_to(existing_point) < 56:
						too_close = true
						break  # Нашли слишком близкую звезду
				
				if not too_close:
					# Точка подходит - добавляем
					points.append(candidate_point)
					point_found = true
			
			# Прерываем, если набрали достаточно точек
			if points.size() >= N:
				return points
	
	# Возвращаем ровно N точек
	return points.slice(0, N)
