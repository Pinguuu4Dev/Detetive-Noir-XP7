extends Node2D
## Gerenciador da cena principal que controla como a cena irá progredir

## Para poder guardar qual 'timeline' está em cena atualmente
var cur_timeline: DialogicTimeline
## Para poder sabermos se uma timeline está acontecendo ou não
var timeline_playing:= false 
@onready var interactable_items = $Scene_Elements/Placeholder_BG/Interactable_Items
@onready var animation_player = $Scene_Elements/AnimationPlayer
@onready var audio_player = $Audio_Player

@export_category("Próxima Cena")
@export var next_scene: PackedScene

# Chamado quando o jogo inicia
func _ready() -> void:
	Dialogic.timeline_started.connect(_on_timeline_started) # Fazer com que o sinal de quando a 'timeline' inicia seja conectada com a função deste script
	Dialogic.timeline_ended.connect(_on_timeline_ended) # Fazer com que o sinal de quando a 'timeline' termina seja conectada com a função deste script

	animation_player.play("Fade_In")

## Função quando o sinal de 'item_collected' dos itens ser ativado
func _on_item_interacted(i: Item) -> void:
	match i.item_type:
		"phone": 
			Dialogic.start("office_phone_call")
		_:
			Dialogic.start("office_" + i.item_type)
			
## Quando uma timeline começar
func _on_timeline_started() -> void:
	cur_timeline = Dialogic.current_timeline #  Guarda qual timeline é na variável
	timeline_playing = true # Diz que tem uma timeline ativa
	print("'", cur_timeline.get_identifier(), "'", " começou: ", timeline_playing) # Debug pra indicar qual timeline está tocando e se realmente está tocando
	
## Quando uma timeline terminar 
func _on_timeline_ended() -> void:
	timeline_playing = false # Diz que a timeline não está ativa
	print("'", cur_timeline.get_identifier(), "'", " terminou: ", !timeline_playing) # Debug pra indicar qual timeline está terminou e se realmente está terminado
	if cur_timeline.get_identifier() == "office_phone_call":
		animation_player.play("Fade_Out")
		await animation_player.animation_finished
		get_tree().change_scene_to_packed(next_scene)
	cur_timeline = null
