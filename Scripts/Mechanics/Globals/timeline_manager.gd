extends Node

var notebook_ref: Notebook
var correct_lines: Array[String]
## Para poder guardar qual 'timeline' está em cena atualmente
var cur_timeline: DialogicTimeline
## Para poder sabermos se uma timeline está acontecendo ou não
var timeline_playing:= false 
## Objetos que devem ser interagidos pelo jogador antes de seguir a timeline
var timelines_finished: Array[String] = []

func _ready() -> void:
	Dialogic.timeline_started.connect(_on_timeline_started) # Fazer com que o sinal de quando a 'timeline' inicia seja conectada com a função deste script
	Dialogic.timeline_ended.connect(_on_timeline_ended) # Fazer com que o sinal de quando a 'timeline' termina seja conectada com a função deste script

func _check_complete_timelines(t: String) -> bool:
	return timelines_finished.has(t)
	
func _get_door_timeline() -> String:
	if !_check_complete_timelines("beco_metal_door_1") and !_check_complete_timelines("beco_notebook_4"):
		return "beco_metal_door_1"
	if _check_complete_timelines("beco_notebook_4"):
		return "beco_metal_door_2"
	else:
		return "beco_incomplete_scene_3"
	
func _get_trash_timeline() -> String:
	if !_check_complete_timelines("beco_trash_1") and !_check_complete_timelines("beco_trash_2"):
		if _check_complete_timelines("beco_metal_door_1") and _check_complete_timelines("beco_notebook_1"):
			if !PuzzleManager.puzzle_started:
				PuzzleManager.puzzle_started = true
			notebook_ref._remove_blood(1); notebook_ref._remove_blood(4)
			return "beco_trash_2"
		else:
			return "beco_trash_1"
	elif !_check_complete_timelines("beco_trash_3"):
		if !PuzzleManager.puzzle_started:
			PuzzleManager.puzzle_started = true
		notebook_ref._remove_blood(1); notebook_ref._remove_blood(4)
		return "beco_trash_3"
	elif !_check_complete_timelines("beco_trash_4") and correct_lines.has("1") and correct_lines.has("4"):
		notebook_ref._remove_blood(2); notebook_ref._remove_blood(3)
		return "beco_trash_4"
	else:
		return "beco_incomplete_scene_2"
	
func _get_notebook_timeline() -> String:
	if !_check_complete_timelines("beco_notebook_1") and !_check_complete_timelines("beco_trash_2") and !_check_complete_timelines("beco_trash_3"):
		return "beco_notebook_1"
	elif !_check_complete_timelines("beco_notebook_2"):
		return "beco_notebook_2"
	elif !_check_complete_timelines("beco_notebook_3") and _check_complete_timelines("beco_trash_4"):
		return "beco_notebook_3"
	elif !_check_complete_timelines("beco_notebook_4") and correct_lines.has("2") and correct_lines.has("3"):
		notebook_ref._remove_blood(5)
		return "beco_notebook_4"
	else:
		return "beco_incomplete_scene_1"

## Quando uma timeline começar.
func _on_timeline_started() -> void:
	cur_timeline = Dialogic.current_timeline #  Guarda qual timeline é na variável
	timeline_playing = true # Diz que tem uma timeline ativa
	print("'", cur_timeline.get_identifier(), "'", " começou: ", timeline_playing) # Debug pra indicar qual timeline está tocando e se realmente está tocando

## Quando uma timeline terminar.
func _on_timeline_ended() -> void:
	timeline_playing = false # Diz que a timeline não está ativa
	print("'", cur_timeline.get_identifier(), "'", " terminou: ", !timeline_playing) # Debug pra indicar qual timeline está terminou e se realmente está terminado
	if !timelines_finished.has(cur_timeline.get_identifier()) and cur_timeline.get_identifier() != "beco_start":
		timelines_finished.append(cur_timeline.get_identifier())
		
	cur_timeline = null
