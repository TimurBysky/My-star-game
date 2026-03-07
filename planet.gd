extends Node3D
@onready var animation: AnimationPlayer = $Planet_model/AnimationPlayer
@onready var camera = $Camera3D
@onready var UI = $UI_Layer
 
@onready var science_label = $UI_Layer/UI/MarginContainer/VBoxContainer3/science_label
@onready var food_label = $UI_Layer/UI/MarginContainer/VBoxContainer3/food_label
@onready var industry_label = $UI_Layer/UI/MarginContainer/VBoxContainer3/industry_label
var tween: Tween
var before
var after
var speed = 0.25
var current_layer: int
var galaxy_camera: Camera3D
var galaxy_UI: CanvasLayer

signal update_status

var performance = \
{
	"science" :0,
	"food" : 0,
	"industry" : 0
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	before = $Planet_model.scale
	after = $Planet_model.scale + Vector3(0.5, 0.5, 0.5)
	$MouseZone.mouse_entered.connect(self.planet_in)
	$MouseZone.mouse_exited.connect(self.planet_out)
	add_to_group("Planets")
# Устанавливаем visual_layer для всех дочерних 3D объектов (кроме Area3D и Camera3D)
	for child in self.get_children():
		if child is Node3D:
			if not child is Area3D and not child is Camera3D:
				child.layers = current_layer  # Правильно для 3D!
				print(current_layer)
	update_status.connect(show_status)
	camera.cull_mask = current_layer

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
		
func activate_UI(_galaxy_camera: Camera3D, _galaxy_UI: CanvasLayer):
	galaxy_camera = _galaxy_camera
	galaxy_UI = _galaxy_UI
	galaxy_camera.current = false
	galaxy_UI.visible = false
	UI.visible = true
	camera.current = true
	emit_signal("update_status")
	
func diactivate_UI():
	galaxy_camera.current = true
	galaxy_UI.visible = true
	camera.current = false
	UI.visible = false

func show_status():
	var science_value = performance.get("science") # или performance["science"]
	var food_value = performance.get("food")
	var industry_value = performance.get("industry")
	
	science_label.text = "Уровень науки: " + str(science_value)
	food_label.text =  "Уровень еды: " + str(food_value)
	industry_label.text =  "Уровень промышленности: " + str(industry_value)
	print("status")
	
func _on_exit_button_pressed() -> void:
	diactivate_UI()
