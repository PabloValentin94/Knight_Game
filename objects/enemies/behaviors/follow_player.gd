extends Node

var inimigo: Enemy

@export_range(0,10) var velocidade_movimento: float = 1

var sentido_movimento: Vector2 = Vector2(0,0)

var imagem_inimigo: AnimatedSprite2D

func _ready() -> void:
	
	inimigo = get_parent()
	
	imagem_inimigo = inimigo.get_node("Corpo/Imagem")

func _physics_process(_delta: float) -> void:
	
	# Utilizando uma variável global.
	
	var coordenadas_atuais_player: Vector2 = Global.coordenadas_player
	
	var distancia: Vector2 = coordenadas_atuais_player - inimigo.position
	
	# Fazendo com que os índices do vetor sejam iguais a 1 ou -1.
	# Para entender melhor, pesquise sobre normalização de vetores.
	
	sentido_movimento = distancia.normalized()
	
	inimigo.velocity = sentido_movimento * (velocidade_movimento * 100)
	
	inimigo.move_and_slide()
	
	Mirror_Image()

func Mirror_Image() -> void:
	
	# Verificando o sentido horizontal para qual o inimigo está correndo.
		
	if sentido_movimento.x > 0:
		
		# Redefinindo o sentido horizontal original da imagem.
		
		imagem_inimigo.flip_h = false
		
	elif sentido_movimento.x < 0:
		
		# Espelhando a imagem.
		
		imagem_inimigo.flip_h = true
