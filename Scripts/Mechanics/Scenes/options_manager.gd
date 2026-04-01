extends Control
class_name Options_Manager
## Controla como o menu de opções funciona

## Resume o jogo de onde parou
func _resume_game() -> void:
	get_tree().paused = false
	
## Pausa o jogo
func _pause_game() -> void:
	get_tree().paused = true
	
func _process(delta: float) -> void:
	pass
	
## Quando o jogador apertar o 'esc' para pausar, irá chamar essa função
func _input(event: InputEvent) -> void:
	if get_tree().current_scene.name != "Menu_Screen":
		if event.is_action_pressed("pause_game") and !get_tree().paused:
			_pause_game()
		if event.is_action_pressed("pause_game") and get_tree().paused:
			_resume_game()
