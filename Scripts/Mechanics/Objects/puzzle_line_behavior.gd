extends Control
class_name PuzzleLine

var hovered:= false
var selected:= false
var initial_pos: Vector2

@export_range(1.1, 2, 0.1) var scale_up = 1.3
var original_scale:= Vector2(1, 1)

func _ready() -> void:
	initial_pos = global_position

func _process(delta: float) -> void:
	pass
	
func _on_mouse_entered() -> void:
	hovered = true
	if !selected:
		scale = Vector2(scale_up, scale_up)
	
func _on_mouse_exited() -> void:
	hovered = false
	if !selected:
		scale = original_scale
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact_with_items") and !PuzzleManager.selected_line and hovered:
		PuzzleManager.selected_line = self
		_on_line_selected(true)
		
func _on_line_selected(b: bool) -> void:
	if b:
		selected = true
		scale = Vector2(scale_up, scale_up)
	else:
		selected = false
		hovered = false
		scale = original_scale
