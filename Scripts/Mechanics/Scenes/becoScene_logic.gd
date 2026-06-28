extends Node2D
class_name BecoManager
## Gerenciador da cena do beco que controla como a cena irá progredir

@export var tip_label: Label
var notebook_ref: Notebook = null
var has_trash = false

@onready var interactable_items = $Scene_Elements/Beco_BG/Interactable_Items
@onready var animation_player = $Scene_Elements/AnimationPlayer

@export_category("Próxima Cena")
@export var next_scene: PackedScene

var current_item: Item
var current_tips: int = 0

func _ready() -> void:
	SaveManager.load_save()
	
	TimelineManager.becoManager = self
	notebook_ref = $Scene_Elements/Beco_BG/Interactable_Items/NotebookPuzzle
	animation_player.play("Fade_In")
	await animation_player.animation_finished
	Dialogic.start("beco_start")
	
func increase_tips(last_tip: bool) -> void:
	if !current_item.any_tips_left:
		return
	
	current_tips += 1
	if last_tip:
		current_item.any_tips_left = false
		
	tip_label.text = "Pistas: " + str(current_tips) + " /14"
	
## Função quando o sinal de 'item_collected' dos itens ser ativado
func _on_item_interacted(i: Item) -> void:
	current_item = i
	
	match i.item_type:
		"metal_door":
			if !TimelineManager._check_complete_timelines("beco_metal_door_2"):
				Dialogic.start(TimelineManager._get_door_timeline())
			else:
				animation_player.play("Fade_Out")
				await animation_player.animation_finished
				TimelineManager.becoManager = null
				get_tree().change_scene_to_packed(next_scene)
		"notebook":
			var notebook_timeline: String = TimelineManager._get_notebook_timeline()
			# Não começa uma timeline caso o jogador esteja nas 2 primeiras frases do puzzle
			if notebook_timeline != "":
				Dialogic.start(notebook_timeline)
		"trash":
			Dialogic.start(TimelineManager._get_trash_timeline())
		"book":
			if !Dialogic.VAR.got_book:
				Dialogic.start("beco_" + i.item_type)
				Dialogic.VAR.got_book = true
			else:
				Dialogic.start("beco_book_done")
		"window":
			if TimelineManager._check_complete_timelines("beco_trash_1") or TimelineManager._check_complete_timelines("beco_trash_2") or TimelineManager._check_complete_timelines("beco_trash_3"):
				Dialogic.start("beco_window")
			else:
				Dialogic.start("beco_window_incomplete")
		_:
			Dialogic.start("beco_" + i.item_type)
