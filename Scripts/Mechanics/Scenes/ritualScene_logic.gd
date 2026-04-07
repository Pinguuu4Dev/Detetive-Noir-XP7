extends Node
## Controla como a sala do ritual irá progredir

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.start("ritualRoom_start")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
