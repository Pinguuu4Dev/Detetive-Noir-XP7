extends Node
class_name Item

# Pra colocar um tipo para o item, default sendo 'leek'
@export var item_type:= "leek"

# Sinal para comunicar com outros scripts
signal item_collected(i_type: Item)

# Roda a cada tick do jogo
func _process(delta: float) -> void:
	pass

# Função para mudar o cursor com o sinal do sprite de quando o mouse entra
func _change_cursor() -> void:
	Input.set_custom_mouse_cursor(item_manager.grab_mouse_icon)
	
# Função para resetar o cursor com o sinal do sprite de quando o mouse sai
func _reset_cursor() -> void:
	Input.set_custom_mouse_cursor(item_manager.default_mouse_icon)
	
# Função para mudar o ícone para segurando enquanto o jogador estiver segurando enquanto está com o mouse no item
func object_is_held(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("interact_with_items"):
		Input.set_custom_mouse_cursor(item_manager.grabbing_mouse_icon)
		item_collected.emit(self) # Emite o sinal de item coletado
		queue_free() # Destrói o item
		Input.set_custom_mouse_cursor(item_manager.default_mouse_icon) # Reseta o cursor do mouse
