extends Area2D
class_name Selectable

var hovered:= false
var puzzleLine_ref: PuzzleLine

@export_range(1.1, 2, 0.1) var scale_up = 1.3
var original_scale:= Vector2(1, 1)

func _on_mouse_entered() -> void:
	_hover(true)
	PuzzleManager._set_hovered_area(self)
	print("Hovered area of Manager: '", name.substr(name.length() - 1), "' has line: '", puzzleLine_ref, "'.")
		
func _on_mouse_exited() -> void:
	_hover(false)
	PuzzleManager._set_hovered_area(null)
		
func _set_line(p: PuzzleLine):
	p.position = global_position
	puzzleLine_ref = p
	print("Area '", self.name, "' has line '", puzzleLine_ref)
	
	PuzzleManager._add_occupied_area(self)

func _clear_line():
	puzzleLine_ref = null

func _hover(h: bool):
	if h:
		hovered = true
		scale = Vector2(scale_up, scale_up)
	else:
		hovered = false
		scale = original_scale
