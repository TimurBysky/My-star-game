class_name GalaxyGeneration3D
extends Node

func generate_jittered_points_3d(
	N: int, 
	width: float, 
	depth: float, 
	height: float = 0.0,  # Фиксированная высота для ВСЕХ точек
	jitter_strength: float = 0.5,
	min_distance: float = 1.0
) -> Array[Vector3]:
	
	var points: Array[Vector3] = []
	
	# 1. Рассчитываем размер сетки для 2D плоскости (XZ)
	var cols: int = ceili(sqrt(N * width / depth))
	var rows: int = ceili(sqrt(N * depth / width))
	
	# Корректируем, если сетка слишком маленькая
	while cols * rows < N:
		cols += 1
		rows += 1
	
	# 2. Размеры ячейки
	var cell_width: float = width / cols
	var cell_depth: float = depth / rows
	
	# 3. Максимальное смещение ТОЛЬКО в X и Z
	var max_jitter_x: float = cell_width * jitter_strength * 0.5
	var max_jitter_z: float = cell_depth * jitter_strength * 0.5
	
	# 4. Генератор случайных чисел (ВАЖНО: инициализировать один раз!)
	var rng = RandomNumberGenerator.new()
	rng.randomize()  # ← КЛЮЧЕВАЯ СТРОКА!
	
	# 5. Заполняем сетку
	for row in range(rows):
		for col in range(cols):
			if points.size() >= N:
				return points
			
			var attempts = 0
			var max_attempts = 20
			var point_found = false
			
			while not point_found and attempts < max_attempts:
				attempts += 1
				
				# Центр ячейки
				var center_x: float = (col + 0.5) * cell_width
				var center_z: float = (row + 0.5) * cell_depth
				
				# Случайное смещение ТОЛЬКО в X и Z
				var offset_x: float = rng.randf_range(-max_jitter_x, max_jitter_x)
				var offset_z: float = rng.randf_range(-max_jitter_z, max_jitter_z)
				
				# Финальная точка в плоскости XZ
				var x: float = clampf(center_x + offset_x, 0.0, width)
				var z: float = clampf(center_z + offset_z, 0.0, depth)
				
				# ВЫСОТА ВСЕГДА ОДИНАКОВАЯ - параметр height!
				var candidate_point = Vector3(x, height, z)
				
				# Проверяем расстояние в 3D (но по сути 2D, так как Y одинаковый)
				var too_close = false
				for existing_point in points:
					if candidate_point.distance_to(existing_point) < min_distance:
						too_close = true
						break
				
				if not too_close:
					points.append(candidate_point)
					point_found = true
	
	return points.slice(0, N)
