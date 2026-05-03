extends Control
class_name PuzzleLine

var hovered:= false
var selected:= false
var can_interact:= false
var inside_area: Selectable
var initial_pos:= Vector2(100, 100)

@onready var a_player:= $AnimationPlayer
@onready var blood:= %Blood

@export_range(1.1, 2, 0.1) var scale_up = 1.3

var new_scale = Vector2(scale_up, scale_up)
var original_scale:= Vector2(1, 1)

func _ready() -> void:
	initial_pos = position

func _enable_interaction():
	can_interact = true

func _on_mouse_entered() -> void:
	if !selected and !inside_area and can_interact:
		_hover(true)
		Input.set_custom_mouse_cursor(CursorManager.hover_icon)
		
func _on_mouse_exited() -> void:
	if !selected and !inside_area and can_interact:
		_hover(false)
		Input.set_custom_mouse_cursor(CursorManager.default_icon)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact_with_items"):
		if hovered or selected:
			if !inside_area and can_interact:
				PuzzleManager._set_selected_line(self)
				Input.set_custom_mouse_cursor(CursorManager.grab_icon)
			
func _selected(b: bool) -> void:
	if b:
		selected = true
		_hover(false)
		%Line_Areas.visible = true
		scale = new_scale
	else:
		selected = false
		%Line_Areas.visible = false
		scale = original_scale
		
func _set_in_area(area: Selectable):
	inside_area = area
	
func _hover(h: bool):
	if h:
		hovered = true
		scale = new_scale
	else:
		hovered = false
		scale = original_scale
