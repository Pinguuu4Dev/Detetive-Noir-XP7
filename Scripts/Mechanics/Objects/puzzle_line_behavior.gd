extends Node2D
class_name PuzzleLine

var draggable:= false
var is_inside_droppable:= false
var droppable_ref: Droppable
var offset: Vector2
var initial_pos: Vector2

@export var line_inside_collision: RichTextLabel = null

var scale_up:= Vector2(1.3, 1.3)
var original_scale:= Vector2(1, 1)

func _ready() -> void:
	if line_inside_collision != null:
		add_child(line_inside_collision)
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
			if is_inside_droppable and !droppable_ref.has_body:
				tween.tween_property(self, "position", droppable_ref.position, 0.2).set_ease(Tween.EASE_OUT)
				droppable_ref.has_body = true
				droppable_ref.body_ref = self
				print("empty droppable")
			elif droppable_ref.has_body:
				tween.tween_property(droppable_ref.body_ref, "position", position, 0.2).set_ease(Tween.EASE_OUT)
				print("droppable with: ", droppable_ref.body_ref)
				await tween.finished
				tween.tween_property(self, "position", droppable_ref.position, 0.2).set_ease(Tween.EASE_OUT)
				print("droppable with: ", self)
			else:
				tween.tween_property(self, "global_position", initial_pos, 0.2).set_ease(Tween.EASE_OUT)
				print("not in droppable")

func _on_mouse_enter():
	if !PuzzleManager.is_dragging:
		draggable = true
		scale = scale_up
	
func _on_mouse_exit():
	if !PuzzleManager.is_dragging:
		draggable = false
		scale = original_scale
	
func _on_body_enter(body: Droppable):
	is_inside_droppable = true
	droppable_ref = body
	if !body.has_body:
		body.modulate = Color(0.411, 0.716, 1.437, 0.588)

func _on_body_exit(body: Droppable):
	is_inside_droppable = false
	body.modulate = Color(0.852, 1.284, 2.224, 0.431)
