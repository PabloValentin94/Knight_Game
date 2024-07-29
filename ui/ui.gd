extends CanvasLayer

@onready var temporizador: Label = %Temporizador

var tempo_segundos_nao_arredondado: float = 0

func _process(delta: float) -> void:
	
	tempo_segundos_nao_arredondado += delta
	
	# Arredondando o tempo, em formato decimal, para o inteiro
	# anterior mais próximo.
	
	var tempo_segundos_arredondado: int = floori(tempo_segundos_nao_arredondado)
	
	# Obtendo os minutos (Aparentemente, o arredondamento ocorre de
	# forma automática.).
	
	var minutos: int = tempo_segundos_arredondado / 60
	
	# Obtendo os segundos (Resto).
	
	var segundos: int = tempo_segundos_arredondado % 60
	
	# Definindo uma propriedade de texto com um valor formatado.
	
	temporizador.text = "%02d:%02d" % [minutos, segundos]
