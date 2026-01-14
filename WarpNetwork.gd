class_name WarpNetwork
extends Node

#func build_warps(warps: Line2D):
	#self.warps = warps
	#var all_stars = get_tree().get_nodes_in_group("Stars")
	#for star in all_stars:
		#warps.add_point(star.position)

func generate_nearest_connections(warp_lines: Line2D, max_connections = 1, max_distance = 300):
	var all_stars = get_tree().get_nodes_in_group("Stars")
	warp_lines.clear_points()
	
	for star in all_stars:
		# Находим ближайшие звёзды
		var nearby_stars = []
		
		for other_star in all_stars:
			if star == other_star:
				continue
				
			var distance = star.position.distance_to(other_star.position)
			if distance < max_distance:
				nearby_stars.append({"star": other_star, "distance": distance})
		
		# Сортируем по расстоянию
		nearby_stars.sort_custom(func(a, b): return a["distance"] < b["distance"])
		
		# Соединяем с ближайшими (но не более max_connections)
		var connections = min(nearby_stars.size(), max_connections)
		for i in range(connections):
			var target = nearby_stars[i]["star"]
			warp_lines.add_point(star.position)
			warp_lines.add_point(target.position)
