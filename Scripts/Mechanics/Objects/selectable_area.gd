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
		selected = true
		_on_selected()
		if !self.puzzleLine_ref:
			_set_puzzleLine(PuzzleManager.selected_line)
		else:
			var temp_line
			temp_line = puzzleLine_ref
			PuzzleManager.selected_area = self
			puzzleLine_ref._on_line_selected(false)
			puzzleLine_ref.position = PuzzleManager.selected_line.global_position
			_set_puzzleLine(PuzzleManager.selected_line)
	if event.is_action_released("interact_with_items"):
		selected = false
		_on_selected()
		
func _set_puzzleLine(p: PuzzleLine):
		self.puzzleLine_ref = p
		self.puzzleLine_ref.position = self.global_position
		PuzzleManager.selected_line._on_line_selected(false)
		PuzzleManager._remove_selected_line()
		self.puzzleLine_ref._on_line_selected(false)
		
func _on_selected():
	if selected:
		scale = Vector2(scale_up, scale_up)
	else:
		scale = original_scale
