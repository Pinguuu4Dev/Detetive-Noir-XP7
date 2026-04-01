extends Control
class_name Menu_Manager
## Script para gerenciar como o menu deve agir

@export_category("Level Configurations")
## Qual nível o botão deverá ir (caso tiver um botão de trocar de nível)
@export var level_to: PackedScene

func _process(delta: float) -> void:
	pass

## Quando o botão "Iniciar" for pressionado
func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(level_to) # Vai para cena indicada pelo Level_To

## Quando o botão "Opções" for pressionado
func _on_options_pressed() -> void:
	$Menu_BG.visible = false
	$OptionsScreen/Transition_FX.play("Blur")
	$OptionsScreen.visible = true
