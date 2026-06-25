extends Control
class_name Notebook

@onready var visibility_player: AnimationPlayer = $Visibility_Player
@onready var notebook_audio: AudioStreamPlayer2D = $Notebook_Audio
@onready var areas_data: Array[TextData] = [load("res://Scenes/Puzzle/Resources/text_1.tres"), load("res://Scenes/Puzzle/Resources/text_2.tres"), load("res://Scenes/Puzzle/Resources/text_3.tres"), load("res://Scenes/Puzzle/Resources/text_4.tres"), load("res://Scenes/Puzzle/Resources/text_5.tres")]
@onready var areas_ref: Array[PuzzleText] = [$Panel/Margins/Grid/Area_1, $Panel/Margins/Grid/Starter_1, $Panel/Margins/Grid/Area_2, $Panel/Margins/Grid/Starter_2, $Panel/Margins/Grid/Area_3, $Panel/Margins/Grid/Starter_3, $Panel/Margins/Grid/Area_4, $Panel/Margins/Grid/Starter_4, $Panel/Margins/Grid/Area_5, $Panel/Margins/Grid/Starter_5]

#var save_path = "user://save"
#var save_name = "puzzleSave.tres"

@export var b_scene: BecoManager

var first_time_open:= true

func _ready() -> void:
	TimelineManager.notebook_ref = self
	#_verify_save_path(save_path)
	initialize_texts()
	
func initialize_texts() -> void:
	for text: PuzzleText in areas_ref:
		if text.text_data:
			text.text_data._set_current_sprite(1)
		text.notebook = self
	
#func _verify_save_path(path: String):
	#DirAccess.make_dir_absolute(save_path)

func _open_notebook():
	visibility_player.play("open_notebook")

	if first_time_open:
		first_time_open = false

func _areas_to_clean(text_num: int):
	print("areas_to_clean() chamado com parâmetro " + str(text_num))
	areas_data[text_num - 1]._set_current_sprite(2)
	#ResourceSaver.save(areas_data[text_num - 1], areas_data[text_num - 1].resource_path)
	#areas_data[text_num - 1] = ResourceLoader.load(areas_data[text_num - 1].resource_path)
	
## Chamada depois de deixar as linhas 1 a 4 corretas
func clean_line_5() -> void:
	_areas_to_clean(5)
	
func _on_close_pressed() -> void:
	visible = false
	for i in b_scene.interactable_items.get_children():
		if i != self:
			i.visible = true
