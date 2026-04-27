extends Node2D
## Gerenciador da cena do beco que controla como a cena irá progredir

## Para poder guardar qual 'timeline' está em cena atualmente
var cur_timeline: DialogicTimeline
## Para poder sabermos se uma timeline está acontecendo ou não
var timeline_playing:= false 
## Objetos que devem ser interagidos pelo jogador antes de seguir a timeline
var timelines_finished: Array[String] = []
var notebook_ref: Item = null
var puzzle_done = false

@onready var interactable_items = $Scene_Elements/Beco_BG/Interactable_Items
@onready var animation_player = $Scene_Elements/AnimationPlayer

@export_category("Próxima Cena")
@export var next_scene: PackedScene

func _ready() -> void:
	Dialogic.timeline_started.connect(_on_timeline_started) # Fazer com que o sinal de quando a 'timeline' inicia seja conectada com a função deste script
	Dialogic.timeline_ended.connect(_on_timeline_ended) # Fazer com que o sinal de quando a 'timeline' termina seja conectada com a função deste script
	notebook_ref = $Scene_Elements/Beco_BG/Interactable_Items/Placeholder_Notebook
	
	# Adquire todos os filhos da cena que são do tipo 'item'
	for i in interactable_items.get_children():
		if i is Item:  # Conecta o sinal destes itens com a função deste script
			i.item_interacted_signal.connect(_on_item_interacted)
	
	animation_player.play("Fade_In")
	await animation_player.animation_finished
	Dialogic.start("beco_start")
	
## Função quando o sinal de 'item_collected' dos itens ser ativado
func _on_item_interacted(i: Item) -> void:
	match i.item_type:
		"metal_door":
			if !timelines_finished.has("beco_metal_door_1"):
				Dialogic.start("beco_metal_door_1")
			elif !timelines_finished.has("beco_metal_door_2") and timelines_finished.has("beco_metal_door_1"): #and timelines_finished.has("beco_notebook_4")
				Dialogic.start("beco_metal_door_2")
			elif timelines_finished.has("beco_metal_door_2"):
				animation_player.play("Fade_Out")
				await animation_player.animation_finished
				get_tree().change_scene_to_packed(next_scene)
			else:
				Dialogic.start("beco_incomplete_scene_3")
		"notebook":
			if !timelines_finished.has("beco_notebook_1"):
				Dialogic.start("beco_notebook_1")
			elif !timelines_finished.has("beco_notebook_2") and timelines_finished.has("beco_notebook_1") and (timelines_finished.has("beco_trash_2") or timelines_finished.has("beco_trash_3")):
				Dialogic.start("beco_notebook_2")
			elif !timelines_finished.has("beco_notebook_3") and timelines_finished.has("beco_notebook_2") and timelines_finished.has("beco_trash_4"):
				Dialogic.start("beco_notebook_3")
			elif !timelines_finished.has("beco_notebook_4") and timelines_finished.has("beco_notebook_3"):
				Dialogic.start("beco_notebook_4")
			else:
				Dialogic.start("beco_incomplete_scene_1")
		"trash":
			if !timelines_finished.has("beco_trash_1") and !timelines_finished.has("beco_trash_2"):
				var trash_timeline = "beco_trash_1"
				if timelines_finished.has("beco_notebook_1") and timelines_finished.has("beco_metal_door_1"):
					trash_timeline = "beco_trash_2"
				Dialogic.start(trash_timeline)
			elif !timelines_finished.has("beco_trash_3") and timelines_finished.has("beco_trash_1"):
				Dialogic.start("beco_trash_3")
			elif !timelines_finished.has("beco_trash_4") and timelines_finished.has("beco_notebook_2"):
				Dialogic.start("beco_trash_4")
			else:
				Dialogic.start("beco_incomplete_scene_2")

## Quando uma timeline começar.
func _on_timeline_started() -> void:
	cur_timeline = Dialogic.current_timeline #  Guarda qual timeline é na variável
	timeline_playing = true # Diz que tem uma timeline ativa
	print("'", cur_timeline.get_identifier(), "'", " começou: ", timeline_playing) # Debug pra indicar qual timeline está tocando e se realmente está tocando
	
## Quando uma timeline terminar.
func _on_timeline_ended() -> void:
	timeline_playing = false # Diz que a timeline não está ativa
	print("'", cur_timeline.get_identifier(), "'", " terminou: ", !timeline_playing) # Debug pra indicar qual timeline está terminou e se realmente está terminado
	if !timelines_finished.has(cur_timeline.get_identifier()):
		timelines_finished.append(cur_timeline.get_identifier())
	cur_timeline = null
