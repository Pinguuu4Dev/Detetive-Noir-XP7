extends Area2D
class_name Selectable

var hovered:= false
var puzzleLine_ref: PuzzleLine

@export_range(1.1, 2, 0.1) var scale_up = 1.3
var original_scale:= Vector2(1, 1)

func _on_mouse_entered() -> void:
	_hover(true)
	PuzzleManager._set_hovered_area(self)
	if puzzleLine_ref:
		print("Hovered area of Manager: '", name.substr(name.length() - 1), "' has line: '", puzzleLine_ref.name.substr(puzzleLine_ref.name.length() - 1), "'.")
	else:
		print("Hovered area of Manager: '", name.substr(name.length() - 1), "' is empty.")
		
func _on_mouse_exited() -> void:
	_hover(false)
	PuzzleManager._set_hovered_area(null)
		
func _set_line(p: PuzzleLine):
	puzzleLine_ref = p
	puzzleLine_ref.position = global_position
	print("Line '", puzzleLine_ref.name.substr(puzzleLine_ref.name.length() - 1), "' assigned to area '", name.substr(name.length() - 1), "'. ")
	PuzzleManager._add_occupied_area(self)
	PuzzleManager._clear_values()

func _clear_line():
	puzzleLine_ref = null
	if PuzzleManager.areas_occupied.has(self):
		PuzzleManager.areas_occupied.remove_at(PuzzleManager.areas_occupied.find(self))

func _hover(h: bool):
	if h:
		hovered = true
		scale = Vector2(scale_up, scale_up)
	else:
		hovered = false
		scale = original_scale
