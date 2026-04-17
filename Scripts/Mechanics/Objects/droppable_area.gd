extends Area2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if PuzzleManager.is_dragging:
		visible = true
	else:
		visible = false
