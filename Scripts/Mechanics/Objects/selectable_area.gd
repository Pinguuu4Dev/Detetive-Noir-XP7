extends Area2D
class_name Selectable

var hovered:= false
var puzzleLine_ref: PuzzleLine

@export_range(1.1, 2, 0.1) var scale_up = 1.3
var original_scale:= Vector2(1, 1)

func _on_mouse_entered() -> void:
	_hover(true)
	PuzzleManager._set_hovered_area(self)

func _on_mouse_exited() -> void:
	_hover(false)
	PuzzleManager._set_hovered_area(null)
		
func _set_line(p: PuzzleLine):
	p.position = position
	puzzleLine_ref = p
	puzzleLine_ref._set_in_area(self)
	
	if puzzleLine_ref.name.substr(puzzleLine_ref.name.length() - 1) == name.substr(name.length() - 1):
		TimelineManager.correct_lines.append(name.substr(name.length() - 1))

func _clear_line():
	puzzleLine_ref._set_in_area(null)
	puzzleLine_ref = null

func _hover(h: bool):
	if h:
		hovered = true
		scale = Vector2(scale_up, scale_up)
	else:
		hovered = false
		scale = original_scale
