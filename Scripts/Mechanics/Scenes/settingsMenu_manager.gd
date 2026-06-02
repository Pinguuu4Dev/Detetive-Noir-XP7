extends Control
class_name Settings_Manager
## Controla como o menu de opções funciona
@export_category("Valores Iniciais")
@export_range(0, 1, 0.01, "prefer_slider") var volume_default: float = 0.7

var current_parent: Node
## Variáveis dos nodes na cena do menu de opções
@onready var animation_player = $Transition_FX
@onready var background = $Settings_BG

# usado na hora de mudar o volume de cada bus de áudio
var music_bus_index: int
var sfx_bus_index: int

func _ready() -> void:
	current_parent = get_parent()
	music_bus_index = AudioServer.get_bus_index("Music")
	sfx_bus_index = AudioServer.get_bus_index("SFX")

## Altera o volume do bus Master
func _on_master_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

## Muta e desmuta o bus Master
func _on_master_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)

## Altera o volume do bus de música
func _on_music_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(value))

## Muta e desmuta o bus de música
func _on_music_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(music_bus_index, toggled_on)
	
## Altera o volume do bus de SFX
func _on_sfx_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(value))

## Muta e desmuta o bus de SFX
func _on_sfx_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(sfx_bus_index, toggled_on)

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
