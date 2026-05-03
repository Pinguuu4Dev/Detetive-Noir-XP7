extends Node2D
class_name BecoManager
## Gerenciador da cena do beco que controla como a cena irá progredir

var notebook_ref: Notebook = null
var has_trash = false
	
@onready var interactable_items = $Scene_Elements/Beco_BG/Interactable_Items
@onready var animation_player = $Scene_Elements/AnimationPlayer

@export_category("Próxima Cena")
@export var next_scene: PackedScene

func _ready() -> void:
	notebook_ref = $Scene_Elements/Beco_BG/Interactable_Items/NotebookPuzzle
	animation_player.play("Fade_In")
	await animation_player.animation_finished
	Dialogic.start("beco_start")
	
## Função quando o sinal de 'item_collected' dos itens ser ativado
func _on_item_interacted(i: Item) -> void:
	match i.item_type:
		"metal_door":
			Dialogic.start(TimelineManager._get_door_timeline())
		"notebook":
			Dialogic.start(TimelineManager._get_notebook_timeline())
		"trash":
			Dialogic.start(TimelineManager._get_trash_timeline())
		_:
			Dialogic.start("beco_" + i.item_type)
