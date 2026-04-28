extends Node

var selected_line: PuzzleLine
var selected_area: Selectable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _set_selected_line(line: PuzzleLine):
	print("Selected line of Manager: ", selected_line)
	if !selected_line:
		selected_line = line
	else:
		selected_line._in_line_selected(false)
		selected_line = line
	print("Change selected line to: ", line)
