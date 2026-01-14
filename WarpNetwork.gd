class_name WarpNetwork
extends Node

#func build_warps(warps: Line2D):
	#self.warps = warps
	#var all_stars = get_tree().get_nodes_in_group("Stars")
	#for star in all_stars:
		#warps.add_point(star.position)

func generate_warps(warps: Line2D):
	
	var all_stars = get_tree().get_nodes_in_group("Stars")	
	warps.clear_points()
	
	for i in range(all_stars.size()):
		var stars = all_stars[i]
		
		var connections = randi_range(1, 2)
		
		for j in range(connections):
			var target_index = i
			while i == target_index:
				target_index = randi_range(0, all_stars.size() - 1)
			warps.add_point(stars.position)
			warps.add_point(all_stars[target_index].position)
