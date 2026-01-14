@tool
extends TileMapLayer


@export var starName := "Star":
	set(value):
		starName = value
		$StarName.text = starName
		notify_property_list_changed()

var before = self.scale
var after = self.scale + Vector2(0.5, 0.5)
var speed = 0.25
var tween: Tween

func _ready() -> void:
	#$StarName.text = starName
	$MouseZone.mouse_shape_entered.connect(self.star_in)
	$MouseZone.mouse_shape_exited.connect(self.star_out)
	$MouseZone.input_event.connect(self.on_star_pressed)

	
func star_in(shape_idx = 0):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", after, speed )\
		 .set_trans(Tween.TRANS_BACK)\
		 .set_ease(Tween.EASE_OUT)

	
func star_out(shape_idx = 0):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", before, speed )\
		 .set_trans(Tween.TRANS_BACK)\
		 .set_ease(Tween.EASE_OUT)
		
		
func on_star_pressed(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print("Звезда ", self.position)
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(self, "scale", before, speed )\
			 .set_trans(Tween.TRANS_BACK)\
			 .set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "scale", after, speed )\
			 .set_trans(Tween.TRANS_BACK)\
			 .set_ease(Tween.EASE_OUT)
