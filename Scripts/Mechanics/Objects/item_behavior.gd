extends Node
class_name Item
## Script para configurarmos os itens que forem criados

## Pra colocar um tipo para o item, default sendo 'leek'
@export_category("Parâmetros de Interação")
@export var item_type: String
@export var delete_after_interaction:= true
@export var open_after_interaction:= false

var object_held:= false

## Sinal para comunicar com outros scripts
signal item_interacted_signal(i: Item)

# Roda a cada tick do jogo
func _process(delta: float) -> void:
	pass

## Função para mudar o cursor com o sinal do sprite de quando o mouse entra
func _change_cursor() -> void:
	Input.set_custom_mouse_cursor(CursorManager.hover_icon)
	
## Função para resetar o cursor com o sinal do sprite de quando o mouse sai
func _reset_cursor() -> void:
	Input.set_custom_mouse_cursor(CursorManager.default_icon)
	
## Função para mudar o ícone para segurando enquanto o jogador estiver segurando enquanto está com o mouse no item
func object_is_held(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("interact_with_items"):
		Input.set_custom_mouse_cursor(CursorManager.grab_icon)
		object_held = true
	if event.is_action_released("interact_with_items") and object_held:
		item_interacted_signal.emit(self)
		object_held = false
		if delete_after_interaction:
			queue_free() # Destrói o item
		_reset_cursor() 
		if open_after_interaction:
			
