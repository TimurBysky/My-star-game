extends Node3D
@onready var animation: AnimationPlayer = $Planet_model/AnimationPlayer

var tween: Tween
var before
var after
var speed = 0.25


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	before = $Planet_model.scale
	after = $Planet_model.scale + Vector3(0.5, 0.5, 0.5)
	$MouseZone.mouse_entered.connect(self.planet_in)
	$MouseZone.mouse_exited.connect(self.planet_out)
	add_to_group("Planets")

func planet_in():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($Planet_model, "scale", after, speed )\
		 .set_trans(Tween.TRANS_BACK)\
		 .set_ease(Tween.EASE_OUT)
		
func planet_out():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property($Planet_model, "scale", before, speed )\
		 .set_trans(Tween.TRANS_BACK)\
		 .set_ease(Tween.EASE_OUT)
		

		
