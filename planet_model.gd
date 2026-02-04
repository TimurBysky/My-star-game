extends MeshInstance3D

@export 

var loaded_textures: Array[Texture2D] = []
var current_index = 0

func _ready() -> void:
	var texture = PreloadTextures.TEXTURES[randi() % PreloadTextures.TEXTURES.size()]
	
	var material = StandardMaterial3D.new()
	material.albedo_texture = texture
	material_override = material

#func set_texture(type):
	#match type:
		#"Acid":
			
