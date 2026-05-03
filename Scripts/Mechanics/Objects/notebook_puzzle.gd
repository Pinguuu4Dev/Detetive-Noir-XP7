extends Control
class_name Notebook

@onready var p_lines: Array[PuzzleLine] = [$Notebook_Page/Puzzle_Lines/Puzzle_Line1, $Notebook_Page/Puzzle_Lines/Puzzle_Line2, $Notebook_Page/Puzzle_Lines/Puzzle_Line3, $Notebook_Page/Puzzle_Lines/Puzzle_Line4, $Notebook_Page/Puzzle_Lines/Puzzle_Line5]
@onready var p_areas:= %Line_Areas
@export var b_scene: BecoManager

var first_time_open:= true

func _ready() -> void:
	TimelineManager.notebook_ref = self

func _open_notebook():
	visible = true
	
	for p in p_lines:
		if p.a_player and first_time_open:
			var anim_player_temp: AnimationPlayer
			anim_player_temp = p.a_player
				
			anim_player_temp.play("Display_Text")
			
	if first_time_open:
		first_time_open = false

func _remove_blood(p_int: int):
	p_lines[p_int - 1].a_player.play("Remove_Blood")
	p_lines[p_int - 1]._enable_interaction()
	
func _on_reset_button_pressed() -> void:
	for i in p_lines:
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
	if !TimelineManager.correct_lines.is_empty():
		TimelineManager.correct_lines.clear()

func _on_close_pressed() -> void:
	visible = false
	for i in b_scene.interactable_items.get_children():
		if i != self:
			i.visible = true
