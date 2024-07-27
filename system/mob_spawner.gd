extends Node2D

@export var inimigos: Array[PackedScene]

@onready var pontos_tracado = %Pontos

var timer_geracao_inimigos: float = 0

var inimigos_surgidos_minuto: int = 20

func _process(delta: float) -> void:
	
	timer_geracao_inimigos -= delta
	
	if timer_geracao_inimigos <= 0:
		
		# Calculando quantos inimigos irão surgir no intervalo de um minuto.
		
		var intervalo_surgimento_inimigos: float = 60 / inimigos_surgidos_minuto
		
		timer_geracao_inimigos = intervalo_surgimento_inimigos
		
		# Escolhendo um inimigo aleatório.
		
		var inimigo_aleatorio: PackedScene = inimigos[randi_range(0,inimigos.size() - 1)]
		
		var inimigo: Node = inimigo_aleatorio.instantiate()
		
		# Definindo as coordenadas em que o inimigo irá surgir.
		
		inimigo.global_position = Get_Random_Point()
		
		# Adicionando inimigo na tela.
		
		get_parent().add_child(inimigo)

func Get_Random_Point() -> Vector2:
	
	pontos_tracado.progress_ratio = randf()
	
	return pontos_tracado.global_position
