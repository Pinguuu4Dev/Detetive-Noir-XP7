extends Node

var selected_line: PuzzleLine
var selected_area: Selectable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _remove_selected_line():
	if selected_line:
		selected_line._on_line_selected(false)
		selected_line = null
