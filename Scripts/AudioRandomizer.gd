## Dá play no audio num tempo randomizado dentro de um intervalo específico.
## Precisa de um AudioStreamRandomizer
class_name AudioRandomizer
extends AudioStreamPlayer

@export var disable: bool = false
@export var first_time_wait: float = 5
@export var minimum_interval: float = 1
@export var maximum_interval: float = 10

@onready var timer: Timer = Timer.new()

func _ready() -> void:
	if disable:
		return
		
	add_child(timer)
	timer.start(first_time_wait)
	await timer.timeout
	start_timer()
	timer.timeout.connect(timeout)

func timeout() -> void:
	play()
	start_timer()
	
func start_timer() -> void:
	timer.start(randf_range(minimum_interval, maximum_interval))
