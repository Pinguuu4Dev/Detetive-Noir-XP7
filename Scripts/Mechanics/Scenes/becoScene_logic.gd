extends Node2D
## Gerenciador da cena do beco que controla como a cena irá progredir

## Para poder guardar qual 'timeline' está em cena atualmente
var cur_timeline: DialogicTimeline
## Para poder sabermos se uma timeline está acontecendo ou não
var timeline_playing:= false 
## Objetos que devem ser interagidos pelo jogador antes de seguir a timeline
var notebook_collected: bool
var notebook_ref: Item = null
var puzzle_done = false

@onready var interactable_items_ref = $Interactable_Items

@export_category("Próxima Cena")
@export var next_scene: PackedScene

func _ready() -> void:
	Dialogic.timeline_started.connect(_on_timeline_started) # Fazer com que o sinal de quando a 'timeline' inicia seja conectada com a função deste script
	Dialogic.timeline_ended.connect(_on_timeline_ended) # Fazer com que o sinal de quando a 'timeline' termina seja conectada com a função deste script
	notebook_ref = interactable_items_ref.get_node("Placeholder_Notebook")
	
	# Adquire todos os filhos da cena que são do tipo 'item'
	for i in interactable_items_ref.get_children():
		if i is Item:  # Conecta o sinal destes itens com a função deste script
			i.item_interacted_signal.connect(_on_item_interacted)
			
	Dialogic.start("beco_start")
	
## Função quando o sinal de 'item_collected' dos itens ser ativado
func _on_item_interacted(i: Item) -> void:
	match i.item_type:
		"metal_door":
			if ItemManager._get_interactions("metal_door") == 0:
				ItemManager._add_interactions(i.item_type)
				Dialogic.start(_check_timeline_segment(i, 0))
			elif ItemManager._get_interactions("notebook") >= 4:
				ItemManager._add_interactions(i.item_type)
				Dialogic.start(_check_timeline_segment(i, 0))
			elif ItemManager._get_interactions("metal_door") == 2:
				get_tree().change_scene_to_packed(next_scene)
			else:
				Dialogic.start("beco_incomplete_scene_3")
		"notebook":
			if !notebook_collected:
				ItemManager._add_interactions(i.item_type)
				Dialogic.start(_check_timeline_segment(i, 0))
				notebook_collected = true
			elif ItemManager._get_interactions("trash") >= 1:
				ItemManager._add_interactions(i.item_type)
				Dialogic.start(_check_timeline_segment(i, 0))
			elif ItemManager._get_interactions("notebook") >= 3:
				ItemManager._add_interactions(i.item_type) 
			else:
				Dialogic.start("beco_incomplete_scene_1")
		"trash":
			if ItemManager._get_interactions("trash") == 0:
				ItemManager._add_interactions(i.item_type)
				if ItemManager._get_interactions("notebook") > 0 and ItemManager._get_interactions("metal_door") > 0:
					ItemManager._add_interactions(i.item_type)
				Dialogic.start(_check_timeline_segment(i, 0))
			elif ItemManager._get_interactions("notebook") == 1 and ItemManager._get_interactions("metal_door") > 0:
				if ItemManager._get_interactions("trash") != 2:
					ItemManager._add_interactions(i.item_type)
					Dialogic.start(_check_timeline_segment(i, 3))
				elif ItemManager._get_interactions("trash") >= 2 and puzzle_done:
					ItemManager._add_interactions(i.item_type)
					Dialogic.start(_check_timeline_segment(i, 4))
			else:
				Dialogic.start("beco_incomplete_scene_2")

## Função que verifica quando um item é interagido, qual timeline deve tocar.
func _check_timeline_segment(i: Item, manual_override: int) -> String:
	match i.item_type:
		"trash":
			var trash_segment = ""
			if manual_override == 0:
				trash_segment = "beco_trash_" + str(ItemManager._get_interactions(i.item_type))
			else:
				trash_segment = "beco_trash_" + str(manual_override)
			
			return trash_segment
		"notebook":
			var notebook_segment = ""
			if manual_override == 0:
				notebook_segment = "beco_notebook_" + str(ItemManager.nb_interactions)
			else:
				notebook_segment = "beco_notebook_" + str(manual_override)
			
			return notebook_segment
		"metal_door":
			var door_segment = ""
			if manual_override == 0:
				door_segment = "beco_metal_door_" + str(ItemManager._get_interactions(i.item_type))
			else:
				door_segment = "beco_metal_door_" + str(manual_override)
			
			return door_segment
		_:
			print("error")
			return ""
## Quando uma timeline começar.
func _on_timeline_started() -> void:
	cur_timeline = Dialogic.current_timeline #  Guarda qual timeline é na variável
	timeline_playing = true # Diz que tem uma timeline ativa
	print("'", cur_timeline.get_identifier(), "'", " começou: ", timeline_playing) # Debug pra indicar qual timeline está tocando e se realmente está tocando
	
## Quando uma timeline terminar.
func _on_timeline_ended() -> void:
	timeline_playing = false # Diz que a timeline não está ativa
	print("'", cur_timeline.get_identifier(), "'", " terminou: ", !timeline_playing) # Debug pra indicar qual timeline está terminou e se realmente está terminado
	cur_timeline = null
