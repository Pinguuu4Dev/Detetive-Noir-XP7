extends Node2D


var leeks_obtained:= 0 # Identificar quantos objetos do tipo 'leek' foram obtidos
var cur_timeline: DialogicTimeline # Para poder guardar qual 'timeline' está em cena atualmente
var timeline_playing:= false # Para poder sabermos se uma timeline está acontecendo ou não

# Chamado quando o jogo inicia
func _ready() -> void:
	Dialogic.timeline_started.connect(_on_timeline_started) # Fazer com que o sinal de quando a 'timeline' inicia seja conectada com a função deste script
	Dialogic.timeline_ended.connect(_on_timeline_ended) # Fazer com que o sinal de quando a 'timeline' termina seja conectada com a função deste script
	
	Dialogic.start("main_timeline") # Inicia a timeline inicial do jogo
	
	# Adquire todos os filhos da cena que são do tipo 'item'
	for i in get_children():
		if i is Item:
			i.item_collected.connect(_on_item_collected) # Conecta o sinal destes itens com a função deste script

# Roda a cada tick do jogo
func _process(delta: float) -> void:
	if Dialogic.VAR.main_vars.got_leeks and !timeline_playing: # Verifica se a variável da timeline está verdadeira e se não está rodando
		Dialogic.start("miku_rescued_timeline") # Se cumprir os requisitos, irá tocar a timeline da miku
		
# Função para conectar o sinal de 'item_collected' dos itens de tipo 'item'
func _on_item_collected(i: Item) -> void:
	if i.item_type == "leek": # Quando for detectado que o item tem o tipo de 'leek'
		leeks_obtained += 1 # Adiciona um contador a variável local de 'leeks' coletados
		if leeks_obtained >= 2: # Se o número de 'leeks' coletados for maior ou igual a 2
			Dialogic.VAR.main_vars.set("got_leeks", true) # Ativa a variável de 'got_leeks'

# Quando uma timeline começar
func _on_timeline_started() -> void:
	cur_timeline = Dialogic.current_timeline #  Guarda qual timeline é na variável
	timeline_playing = true # Diz que tem uma timeline ativa
	print("'", cur_timeline.get_identifier(), "'", " começou: ", timeline_playing) # Debug pra indicar qual timeline está tocando e se realmente está tocando
	
# Quando uma timeline terminar 
func _on_timeline_ended() -> void:
	timeline_playing = false # Diz que a timeline não está ativa
	Dialogic.VAR.reset() # Reseta as variáveis da timeline
	print("'", cur_timeline.get_identifier(), "'", " terminou: ", !timeline_playing) # Debug pra indicar qual timeline está terminou e se realmente está terminado
