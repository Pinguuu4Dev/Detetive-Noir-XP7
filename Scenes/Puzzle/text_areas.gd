extends Panel
class_name PuzzleText

## Nomiei de 'text' o sprite do texto que é pra estar sendo mostrado
@onready var text: TextureRect = $Text
## O resource do texto vem aqui, para identificar número e sprites censurados e limpos
@export var text_data: TextData

var notebook: Notebook

## Faz com que o sprite inicial da área seja sempre sua versão censurada
func _ready() -> void:
	#if text_data:
		#ResourceSaver.save(text_data, text_data.resource_path)
		#text_data = ResourceLoader.load(text_data.resource_path)
	## Atualiza a UI por segurança, para que sempre que começe um jogo esteja com os sprites certos
	_update_ui()

func _process(delta: float) -> void:
	_update_ui()
	
## Faz a mudança de texto que está em cada espaço da grid
func _update_ui() -> void:
	## Se não tiver algo dentro do espaço, irá ficar com uma textura vazia
	if !text_data:
		text.texture = null
		return
	
	## Se tiver algo dentro do espaço, irá utilizar o sprite, referenciado no resource do espaço
	text.texture = text_data.current_sprite

## Seleciona a textura que deve ser arrastada para outro espaço
func _get_drag_data(at_position: Vector2) -> Variant:
	## Se não tiver algo no espaço, irá acontecer nada
	if !text_data || text_data.is_censored:
		return
	
	# Remove da lista até o jogador soltar o texto na posição correta
	remove_line(text_data)
	
	## Caso tenha algo no espaço, cria um preview do objeto, para o jogador ver o que ele está arrastando
	var preview = duplicate()
	# Faz com que o preview fique centralizado }
	var c = Control.new() # }
	c.add_child(preview) # }
	preview.position -= Vector2(65, 19) # }
	
	# Faz o preview ter efeito de transparente enquanto estiver sendo arrastado }
	preview.self_modulate = Color.TRANSPARENT # }
	c.modulate = Color(modulate, 0.5) # }
	# Seleciona no sistema base da godot o texto como sendo o node do preview ou alguma coisa assim
	set_drag_preview(c) # }
	text.hide() # } 
	return self # }

## Faz possível o arrastamento de itens do tipo 'textdata'
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if TextData:
		return true
		
	return false

## Após soltar o item, irá adiciona-lô ao espaço que estava sendo arrastado para cima
func _drop_data(at_position: Vector2, data: Variant) -> void:
	# data é de onde o jogador está arrastando
	
	if text_data != null:
		if text_data.is_censored:
			# cancela o drop se o texto no lugar for censurado
			data.text.show()
			return
	
	## Cria um valor temporário caso já tenha uma das frases no espaço }
	# text_data é o texto atual no espaço que o jogador soltou o texto
	var tmp_text = text_data # }
	print(data)
	
	add_line(data.text_data, self)

	if tmp_text != null && tmp_text != data.text_data:
		remove_line(tmp_text)
		# checa se o texto que estava no lugar está sendo trocado para o lugar correto
		add_line(tmp_text, data) 
	
	## Faz com que o espaço selecionado tenha o novo texto atribuído a ele } 
	text_data = data.text_data # }
	# e caso necessário, troca o texto que estava anteriormente nele
	data.text_data = tmp_text # }
	## Faz ser visível o texto novo
	text.show() # } 
	data.text.show() # }
	_update_ui() # } 
	data._update_ui() # }

## Testa se o texto está no lugar correto e adiciona no array. Também gerencia os diálogos.
func add_line(text_data: TextData, new_place: PuzzleText) -> void:
	
	if !new_place.name.begins_with("A"):
		return
		
	# se o nome começar com "A" ->
	if str(text_data.text_num) != new_place.name.substr(new_place.name.length() - 1):
		print("Texto " + str(text_data.text_num) + " no local " + 
			str(new_place.name.substr(new_place.name.length() - 1)))
		print("Texto no lugar incorreto")
		return
		
	# se o texto estiver no lugar correto ->
	# adiciona texto no array e chama os diálogos
	TimelineManager.correct_lines.append(int(new_place.name.substr(new_place.name.length() - 1)))
	print("Adding " + str(text_data.text_num) + " to array")
	if (TimelineManager.correct_lines.has(1) && 
		TimelineManager.correct_lines.has(2)):
			if (TimelineManager.correct_lines.has(3) &&
				TimelineManager.correct_lines.has(4) &&
				!TimelineManager.correct_lines.has(5)):
				TimelineManager.clean_text_5()
				Dialogic.start("beco_notebook_4")
			elif !TimelineManager._check_complete_timelines("beco_notebook_3"):
				Dialogic.start("beco_notebook_3")

## Remove o texto do array caso esteja nele.
func remove_line(data_to_remove: TextData) -> void:
	if TimelineManager.correct_lines.has(data_to_remove.text_num):
		TimelineManager.correct_lines.erase(data_to_remove.text_num)
		print("Removing " + str(data_to_remove.text_num) + " from array")
