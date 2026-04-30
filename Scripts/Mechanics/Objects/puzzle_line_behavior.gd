extends Control
class_name PuzzleLine

var hovered:= false
var selected:= false
var initial_pos: Vector2

@export_range(1.1, 2, 0.1) var scale_up = 1.3
var new_scale = Vector2(scale_up, scale_up)
var original_scale:= Vector2(1, 1)

func _ready() -> void:
	initial_pos = global_position

func _on_mouse_entered() -> void:
	if !selected:
		_hover(true)
		
func _on_mouse_exited() -> void:
	if !selected:
		_hover(false)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact_with_items"):
		if hovered:
			PuzzleManager._set_selected_line(self)
		elif selected:
			PuzzleManager._set_selected_line(self)
		
func _selected(b: bool) -> void:
	if b:
		selected = true
		_hover(false)
		%Line_Areas.visible = true
		scale = new_scale
	else:
		selected = false
		%Line_Areas.visible = false
		scale = original_scale
		
func _hover(h: bool):
	if h:
		hovered = true
		scale = new_scale
	else:
		hovered = false
		scale = original_scale
