extends Node2D

@onready var p_lines:= $Notebook_Page/Puzzle_Lines
@onready var p_areas:= %Line_Areas

func _on_reset_button_pressed() -> void:
	for i in p_lines.get_children():
		if i is PuzzleLine:
			i.position = i.initial_pos
			i._set_in_area(null)
	for i in p_areas.get_children():
		if i is Selectable:
			if i.puzzleLine_ref:
				i._clear_line()
			
	if PuzzleManager.hovered_area:
		PuzzleManager._clear_values(PuzzleManager.hovered_area)
		
	if PuzzleManager.selected_line:
		PuzzleManager._clear_values(PuzzleManager.selected_line)
