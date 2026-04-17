extends Node2D

var draggable = false
var is_inside_droppable = false
var droppable_ref 
var offset: Vector2
var initial_pos: Vector2

@export var line_inside_collision: RichTextLabel = null

var scale_up:= Vector2(1.3, 1.3)
var original_scale:= Vector2(1, 1)

func _ready() -> void:
	if line_inside_collision != null:
		add_child(line_inside_collision)
		line_inside_collision.position = Vector2(0,0)
		move_child(line_inside_collision, -1)

func _process(delta: float) -> void:
	if draggable:
		if Input.is_action_just_pressed("interact_with_puzzle"):
			initial_pos = global_position
			offset = get_global_mouse_position() - global_position
			PuzzleManager.is_dragging = true
		if Input.is_action_pressed("interact_with_puzzle"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("interact_with_puzzle"):
			PuzzleManager.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_droppable:
				tween.tween_property(self, "position", droppable_ref.position, 0.2).set_ease(Tween.EASE_OUT)
			else:
				tween.tween_property(self, "global_position", initial_pos, 0.2).set_ease(Tween.EASE_OUT)

func _on_mouse_enter():
	if not PuzzleManager.is_dragging:
		draggable = true
		scale = scale_up
	
func _on_mouse_exit():
	if not PuzzleManager.is_dragging:
		draggable = false
		scale = original_scale
	
func _on_body_enter(body: Node2D):
	if body.is_in_group("droppable"):
		is_inside_droppable = true
		body.modulate = Color(0.181, 0.181, 0.181)
		droppable_ref = body
	
func _on_body_exit(body: Node2D):
	if body.is_in_group("droppable"):
		is_inside_droppable = false
		body.modulate = Color(0.364, 0.364, 0.364)
