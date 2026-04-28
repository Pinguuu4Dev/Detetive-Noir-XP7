extends Node

var selected_line: PuzzleLine
var hovered_area: Selectable
var areas_occupied: Array

func _set_selected_line(line: PuzzleLine):
	var new_pos = line.global_position
	var old_pos: Vector2
	
	if !selected_line:
		selected_line = line
		print("Selected line of Manager: '", selected_line.name.substr(selected_line.name.length() - 1), "'.")
		selected_line._selected(true)
		if !areas_occupied.is_empty():
			for i in areas_occupied:
				if i.puzzleLine_ref == selected_line:
					i._clear_line()
					_clear_values()
					
					selected_line = line
					line._selected(true)
					print("Area '", i.name.substr(i.name.length() - 1),"' removed from occupied.")
	else:
		print("Switched line in manager from: ", selected_line.name, " to: ", line.name)
			
		old_pos = selected_line.global_position
			
		selected_line.position = new_pos
		line.position = old_pos
		line._selected(false)
		_clear_values()
		
func _add_occupied_area(area: Selectable):
	print("Area '", area.name.substr(area.name.length() - 1), "' added to array.")
	areas_occupied.append(area)

func _set_area_line(line: PuzzleLine):
	var new_pos = line.global_position
	var old_pos: Vector2
	if !hovered_area.puzzleLine_ref:
		hovered_area._set_line(line)
	else: 
		print("Switched line in area from: ", hovered_area.puzzleLine_ref.name.substr(hovered_area.puzzleLine_ref.name.length() - 1), " to: ", line.name.substr(line.name.length() - 1))
			
		old_pos = selected_line.global_position
			
		selected_line.position = new_pos
		line.position = old_pos
		line._selected(false)
		_clear_values()

func _set_hovered_area(area: Selectable):
	hovered_area = area
		
func _clear_values():
	if selected_line:
		selected_line._selected(false)
		selected_line = null
	if hovered_area:
		hovered_area._hover(false)
		hovered_area = null
