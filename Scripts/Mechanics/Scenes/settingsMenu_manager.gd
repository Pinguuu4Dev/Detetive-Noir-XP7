extends Control
class_name Settings_Manager
## Controla como o menu de opções funciona
@export_category("Valores Iniciais")
@export_range(0, 1, 0.01, "prefer_slider") var volume_default: float = 0.7

var current_parent: Node
## Variáveis dos nodes na cena do menu de opções
@onready var animation_player = $Transition_FX
@onready var background = $Settings_BG
func _ready() -> void:
	current_parent = get_parent()
## Essa função pega o valor que o usuário colocou de volume e muda as configurações do jogo
func _on_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

## Essa função verifica se a caixa de mutar o jogo foi verificada
func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)

## Essa função verifica qual opção de tela foi selecionada
func _on_screen_options_selected(index: int) -> void:
	match index: 
		0: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		1: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		2: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func _on_done_pressed() -> void:
	match current_parent.name:
		"Menu_Screen": 
			for i in current_parent.get_children():
				if i is AnimationPlayer:
					i.play_backwards("Fade-Out")
					animation_player.play_backwards("Fade-In")
					await i.animation_finished
					visible = false
		"Pause_Screen":
			for i in current_parent.get_children():
				if i is ColorRect:
					animation_player.play_backwards("Fade-In")
					await animation_player.animation_finished
					i.visible = true
					background.visible = false
