extends Node2D
## Gerenciador da cena do beco que controla como a cena irá progredir

## Para poder guardar qual 'timeline' está em cena atualmente
var cur_timeline: DialogicTimeline
## Para poder sabermos se uma timeline está acontecendo ou não
var timeline_playing:= false 
## Objetos que devem ser interagidos pelo jogador antes de seguir a timeline
var notebook_collected: bool
var trash_interactions: int

@export_category("Próxima Cena")
@export var next_scene: PackedScene

# Chamado quando o jogo inicia
func _ready() -> void:
	Dialogic.timeline_started.connect(_on_timeline_started) # Fazer com que o sinal de quando a 'timeline' inicia seja conectada com a função deste script
	Dialogic.timeline_ended.connect(_on_timeline_ended) # Fazer com que o sinal de quando a 'timeline' termina seja conectada com a função deste script

	Dialogic.start("beco_start")
	# Adquire todos os filhos da cena que são do tipo 'item'
	for x in get_children():
		if x.name == "Interactable_Items":
			for i in x.get_children():
				if i is Item:  # Conecta o sinal destes itens com a função deste script
					i.item_interacted_signal.connect(_on_item_interacted)

## Função quando o sinal de 'item_collected' dos itens ser ativado
func _on_item_interacted(i: Item) -> void:
	match i.item_type:
		"notebook":
			if !notebook_collected:
				Dialogic.start("beco_notebook_segment_1")
				notebook_collected = true
				Dialogic.VAR.beco_vars.set("notebook_collected", true)
		"metal_door":
			if notebook_collected:
				Dialogic.start("beco_door_segment_1")
		"trash_1":
			trash_interactions += 1
			Dialogic.start(_check_trash_interactions())
			
func _check_trash_interactions() -> String:
	var trash_segment = "beco_trash_segment_" + str(trash_interactions)
	return trash_segment
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
