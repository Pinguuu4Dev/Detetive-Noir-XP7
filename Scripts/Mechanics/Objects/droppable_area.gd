extends StaticBody2D
class_name Droppable

var has_body: bool
var body_ref: PuzzleLine

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if PuzzleManager.is_dragging:
		visible = true
	else:
		visible = false
