extends Node

var selected_line: PuzzleLine
var hovered_area: Selectable
var puzzle_started:= false

func _set_selected_line(line: PuzzleLine):
	if !selected_line and !hovered_area:
		if line.inside_area:
			line.inside_area._clear_line()
		selected_line = line; 
		selected_line._selected(true)
	elif !hovered_area:
		if selected_line != line:
			_clear_values(selected_line)
			selected_line = line
			selected_line._selected(true)
	else:
		if hovered_area.puzzleLine_ref:
			hovered_area.puzzleLine_ref.position = line.position
			hovered_area._clear_line()
			line.position = hovered_area.position
		_clear_values(selected_line)
		hovered_area._set_line(line)
		_clear_values(hovered_area)
		
		
func _set_hovered_area(area: Selectable):
	hovered_area = area
	
func _clear_values(obj):
	if obj is PuzzleLine:
		selected_line._selected(false)
		selected_line = null
	elif obj is Selectable:
		hovered_area._hover(false)
		hovered_area = null
