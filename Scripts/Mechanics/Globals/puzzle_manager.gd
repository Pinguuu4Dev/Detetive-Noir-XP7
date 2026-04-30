extends Node

var selected_line: PuzzleLine
var hovered_area: Selectable

func _set_selected_line(line: PuzzleLine):
	if !selected_line:
		selected_line = line
		selected_line._selected(true)
	else:
		var old_l_pos = selected_line.global_position
		var old_l = selected_line
		_clear_values(line)
		old_l.position = line.global_position
		line.position = old_l_pos
		
func _set_hovered_area(area: Selectable):
	hovered_area = area
	
func _clear_values(obj):
	if obj is PuzzleLine:
		print("Cleared line")
		selected_line._selected(false)
		selected_line = null
	elif obj is Selectable:
		print("Cleared area")
		hovered_area._hover(false)
		hovered_area = null
