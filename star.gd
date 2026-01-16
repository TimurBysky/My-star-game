@tool
extends Node2D

@export var star_size: Vector2i = Vector2i(2, 2)  # Размер звезды в тайлах
@export var star_variants_count: int = 4  # Количество вариантов звезд
@export var star_row: int = 0  # Номер строки с звездами в атласе
@export var starName := "Star":
	set(value):
		starName = value
		$StarName.text = starName
		notify_property_list_changed()


var before
var after
var speed = 0.25
var tween: Tween

func _ready() -> void:
	$MouseZone.mouse_shape_entered.connect(self.star_in)
	$MouseZone.mouse_shape_exited.connect(self.star_out)
	$MouseZone.input_event.connect(self.on_star_pressed)
	before = self.scale
	after = self.scale + Vector2(0.5, 0.5)
	add_to_group("Stars")

	
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




	
