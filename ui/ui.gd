extends CanvasLayer

@onready var temporizador: Label = %Temporizador

@onready var ui_quantidade_carne: Label = %Quantidade_Carne

@export var quantidade_carne: int = 0

var tempo_segundos_nao_arredondado: float = 0

func _ready() -> void:
	
	# Fazendo com que a função "Invaded_Area" seja executada toda vez
	# que o evento "Area2D.body_entered" ocorrer.
	
	Global.player.Meat_Collected.connect(Add_Meat)

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

# func Add_Meat(valor_regenerado_vida: int) -> void:
func Add_Meat() -> void:
	
	quantidade_carne += 1
	
	ui_quantidade_carne.text = str(quantidade_carne)
