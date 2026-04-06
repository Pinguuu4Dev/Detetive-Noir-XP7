extends CanvasLayer
## Controlar como funciona o pause do jogo

@onready var animation_player = $Pause_FX
@onready var background = $Pause_BG
@onready var options_menu_ref = $Settings_Screen
@onready var options_animationPlayer = null

func _ready() -> void:
	options_animationPlayer = options_menu_ref.get_node("Transition_FX")
	visible = false

## Quando o jogador apertar o 'esc' para pausar, irá verificar se estava no menu ou in-game
func _input(event: InputEvent) -> void: 
	if event.is_action_pressed("pause_game"):
		if get_tree().paused:
			get_tree().paused = false
			animation_player.play_backwards("Blur")
			await animation_player.animation_finished
			visible = false
		else:
			get_tree().paused = true
			visible = true
			animation_player.play("Blur")
			await animation_player.animation_finished

func _on_resume_pressed() -> void:
	get_tree().paused = false
	animation_player.play_backwards("Blur")
	await animation_player.animation_finished
	visible = false

func _on_exit_pressed() -> void:
	get_tree().quit()
