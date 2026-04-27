extends Node
## Controla como a sala do ritual irá progredir

@onready var anim_player = $Scene_Elements/AnimationPlayer

var cur_timeline: DialogicTimeline
var timeline_playing = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.timeline_started.connect(_on_timeline_started) # Fazer com que o sinal de quando a 'timeline' inicia seja conectada com a função deste script
	Dialogic.timeline_ended.connect(_on_timeline_ended) # Fazer com que o sinal de quando a 'timeline' termina seja conectada com a função deste script

	anim_player.play("Fade_In")
	await anim_player.animation_finished
	Dialogic.start("ritualRoom_start")

## Quando uma timeline começar
func _on_timeline_started() -> void:
	cur_timeline = Dialogic.current_timeline #  Guarda qual timeline é na variável
	timeline_playing = true # Diz que tem uma timeline ativa
	print("'", cur_timeline.get_identifier(), "'", " começou: ", timeline_playing) # Debug pra indicar qual timeline está tocando e se realmente está tocando
	
## Quando uma timeline terminar 
func _on_timeline_ended() -> void:
	timeline_playing = false # Diz que a timeline não está ativa
	print("'", cur_timeline.get_identifier(), "'", " terminou: ", !timeline_playing) # Debug pra indicar qual timeline está terminou e se realmente está terminado
	if cur_timeline.get_identifier() == "ritualRoom_start":
		anim_player.play("Fade_Out")
		await anim_player.animation_finished
		get_tree().change_scene_to_file("res://Scenes/UI/Menu_Screen.tscn")
		
	cur_timeline = null
