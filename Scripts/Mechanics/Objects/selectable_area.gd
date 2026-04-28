extends Area2D
class_name Selectable

var hovered:= false
var selected:= false
var puzzleLine_ref: PuzzleLine

@export_range(1.1, 2, 0.1) var scale_up = 1.3
var original_scale:= Vector2(1, 1)


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
	if event.is_action_pressed("interact_with_items") and PuzzleManager.selected_line and hovered:
		_is_selected(true)
		_set_puzzleLine(PuzzleManager.selected_line)
	if event.is_action_released("interact_with_items"):
		_is_selected(false)
		
func _set_puzzleLine(p: PuzzleLine):
	if !puzzleLine_ref:
		self.puzzleLine_ref = p
		self.puzzleLine_ref.position = self.global_position
		print(puzzleLine_ref)
		PuzzleManager._set_selected_line(null)
		print(PuzzleManager.selected_area, " and ", PuzzleManager.selected_line)
		
func _is_selected(b: bool):
	selected = b
	if b:
		scale = Vector2(scale_up, scale_up)
	else:
		scale = original_scale
