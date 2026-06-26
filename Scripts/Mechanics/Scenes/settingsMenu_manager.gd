extends Control
class_name Settings_Manager
## Controla como o menu de opções funciona
@export_category("Valores Iniciais")
@export_range(0, 1, 0.01, "prefer_slider") var volume_default: float = 0.7

@export_category("Components")
@export_group("Audio")
@export var master_volume_slider: HSlider
@export var music_volume_slider: HSlider
@export var sfx_volume_slider: HSlider
@export var master_mute_button: CheckBox
@export var music_mute_button: CheckBox
@export var sfx_mute_button: CheckBox
@export_group("Video")
@export var screen_mode_button: OptionButton

# Arquivo de configs do jogo
var config: ConfigFile = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

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
	load_settings()

func load_settings() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		save_settings()
		return
	
	config.load(SETTINGS_FILE_PATH)
	
	master_volume_slider.value = config.get_value("audio", "master_volume")
	music_volume_slider.value = config.get_value("audio", "music_volume")
	sfx_volume_slider.value = config.get_value("audio", "sfx_volume")
	
	master_mute_button.button_pressed = config.get_value("audio", "master_muted")
	music_mute_button.button_pressed = config.get_value("audio", "music_muted")
	sfx_mute_button.button_pressed = config.get_value("audio", "sfx_muted")
	
	var screen_mode_str: String = config.get_value("video", "screen_mode")
	var screen_mode_int: int
	match screen_mode_str:
		"exclusive_fullscreen": screen_mode_int = 0
		"windowed": screen_mode_int = 1
		"borderless_window": screen_mode_int = 2
	screen_mode_button.selected = screen_mode_int
	_on_screen_options_selected(screen_mode_int)

## Pega os valores nos nós de Control e salva no arquivo config.ini
func save_settings() -> void:
	config.set_value("video", "screen_mode", get_screen_mode())
	
	config.set_value("audio", "master_volume", master_volume_slider.value)
	config.set_value("audio", "music_volume", music_volume_slider.value)
	config.set_value("audio", "sfx_volume", sfx_volume_slider.value)
	
	config.set_value("audio", "master_muted", master_mute_button.button_pressed)
	config.set_value("audio", "music_muted", music_mute_button.button_pressed)
	config.set_value("audio", "sfx_muted", sfx_mute_button.button_pressed)
	
	config.save(SETTINGS_FILE_PATH)

## Retorna ou uma String baseado no modo de tela selecionado
func get_screen_mode() -> String:
	match screen_mode_button.selected:
		0: return "exclusive_fullscreen"
		1: return "windowed"
		2: return "borderless_window"
	return ""

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
	save_settings()
	
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
