extends Node2D
## Gerenciador da cena principal que controla como a cena irá progredir

## Para poder guardar qual 'timeline' está em cena atualmente
var cur_timeline: DialogicTimeline
## Para poder sabermos se uma timeline está acontecendo ou não
var timeline_playing:= false 
@onready var interactable_items = $Scene_Elements/Placeholder_BG/Interactable_Items

@export_category("Próxima Cena")
@export var next_scene: PackedScene

# Chamado quando o jogo inicia
func _ready() -> void:
	Dialogic.timeline_started.connect(_on_timeline_started) # Fazer com que o sinal de quando a 'timeline' inicia seja conectada com a função deste script
	Dialogic.timeline_ended.connect(_on_timeline_ended) # Fazer com que o sinal de quando a 'timeline' termina seja conectada com a função deste script

	# Adquire todos os filhos da cena que são do tipo 'item'
	for i in interactable_items.get_children():
		if i is Item:  # Conecta o sinal destes itens com a função deste script
			i.item_interacted_signal.connect(_on_item_interacted)

## Função quando o sinal de 'item_collected' dos itens ser ativado
func _on_item_interacted(i: Item) -> void:
	match i.item_type:
		"phone": 
			if !Dialogic.VAR.main_vars.picked_phone and !timeline_playing:
				Dialogic.VAR.main_vars.set("picked_phone", true)
				Dialogic.start("office_phone_call")
		"door": 
			if !Dialogic.VAR.main_vars.picked_phone and !timeline_playing:
				Dialogic.start("office_incomplete_scene_1")
			if Dialogic.VAR.main_vars.picked_phone and !timeline_playing:
				get_tree().change_scene_to_packed(next_scene)

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
