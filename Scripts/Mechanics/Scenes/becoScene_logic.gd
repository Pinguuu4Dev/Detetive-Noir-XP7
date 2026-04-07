extends Node2D
## Gerenciador da cena do beco que controla como a cena irá progredir

## Para poder guardar qual 'timeline' está em cena atualmente
var cur_timeline: DialogicTimeline
## Para poder sabermos se uma timeline está acontecendo ou não
var timeline_playing:= false 
## Objetos que devem ser interagidos pelo jogador antes de seguir a timeline
var notebook_collected: bool
var notebook_ref: Item

var trash_interactions: int = 0
var notebook_interactions: int = 0
var door_interactions: int = 0

@onready var hidden_items_on_start = [
	$Interactable_Items/Placeholder_Door,
	$Interactable_Items/Placeholder_Trash,
]
@onready var interactable_items_ref = $Interactable_Items

@export_category("Próxima Cena")
@export var next_scene: PackedScene

signal on_notebook_collected_signal

func _ready() -> void:
	Dialogic.timeline_started.connect(_on_timeline_started) # Fazer com que o sinal de quando a 'timeline' inicia seja conectada com a função deste script
	Dialogic.timeline_ended.connect(_on_timeline_ended) # Fazer com que o sinal de quando a 'timeline' termina seja conectada com a função deste script

	Dialogic.start("beco_start")
	
	Dialogic.VAR.reset()
	on_notebook_collected_signal.connect(_on_notebook_collected_func)
	# Adquire todos os filhos da cena que são do tipo 'item'
	for i in interactable_items_ref.get_children():
		if i is Item:  # Conecta o sinal destes itens com a função deste script
			i.item_interacted_signal.connect(_on_item_interacted)
			
	notebook_ref = interactable_items_ref.get_node("Placeholder_Notebook")
## Função quando o sinal de 'item_collected' dos itens ser ativado
func _on_item_interacted(i: Item) -> void:
	match i.item_type:
		"notebook":
			if !notebook_collected:
				Dialogic.start("beco_notebook_1")
				notebook_collected = true
				Dialogic.VAR.beco_vars.set("notebook_collected", true)
				on_notebook_collected_signal.emit()
				notebook_interactions += 1
			elif trash_interactions >= 1 and notebook_interactions <= 3: 
				notebook_interactions += 1
				Dialogic.start(_check_notebook_segment())
				if notebook_interactions == 2:
					notebook_ref.delete_after_interaction = true
			else:
				Dialogic.start("beco_incomplete_scene_1")
		"metal_door":
			if notebook_collected:
				Dialogic.start(_check_metal_door_timeline())
			else:
				get_tree().change_scene_to_packed(next_scene)
		"trash":
			if trash_interactions <= 1:
				trash_interactions += 1
				Dialogic.start(_check_trash_segment())
			else:
				Dialogic.start("beco_incomplete_scene_2")
## Verificar quantas vezes o lixo foi interagido com para ter diálogos diferentes
func _check_trash_segment() -> String:
	var trash_segment = "beco_trash_" + str(trash_interactions)
	return trash_segment
	
func _check_notebook_segment() -> String:
	var notebook_segment = "beco_notebook_" + str(notebook_interactions)
	return notebook_segment
## Quando o caderno for coletado, deverá fazer os objetos invisíveis ficarem visíveis
func _on_notebook_collected_func() -> void:
	for i in hidden_items_on_start:
		if !i.visible:
			i.visible = true

func _check_metal_door_timeline() -> String:
	if trash_interactions >= 2 and notebook_interactions >= 3:
		door_interactions += 1
		notebook_collected = false
	elif door_interactions == 0:
		door_interactions += 1
	else:
		Dialogic.start("beco_incomplete_scene_3")
		
	var door_segment = "beco_metal_door_" + str(door_interactions)
	return door_segment
	
## Quando uma timeline começar
func _on_timeline_started() -> void:
	cur_timeline = Dialogic.current_timeline #  Guarda qual timeline é na variável
	timeline_playing = true # Diz que tem uma timeline ativa
	print("'", cur_timeline.get_identifier(), "'", " começou: ", timeline_playing) # Debug pra indicar qual timeline está tocando e se realmente está tocando
	
## Quando uma timeline terminar 
func _on_timeline_ended() -> void:
	timeline_playing = false # Diz que a timeline não está ativa
	print("'", cur_timeline.get_identifier(), "'", " terminou: ", !timeline_playing) # Debug pra indicar qual timeline está terminou e se realmente está terminado
	cur_timeline = null
