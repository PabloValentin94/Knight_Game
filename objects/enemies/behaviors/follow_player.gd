extends CharacterBody2D

@export_range(1,10) var velocidade_movimento: float = 1.5

var sentido_movimento: Vector2 = Vector2(0,0)

@onready var imagem_inimigo: AnimatedSprite2D = $Corpo/Imagem

func _physics_process(_delta: float) -> void:
	
	var coordenadas_player: Vector2 = Vector2(0,0)
	
	var distancia: Vector2 = coordenadas_player - position
	
	# Fazendo com que os índices do vetor sejam iguais a 1 ou -1.
	# Para entender melhor, pesquise sobre normalização de vetores.
	
	sentido_movimento = distancia.normalized()
	
	velocity = sentido_movimento * (velocidade_movimento * 100)
	
	move_and_slide()
	
	Mirror_Image()

func Mirror_Image() -> void:
	
	# Verificando o sentido horizontal para qual o inimigo está correndo.
		
	if sentido_movimento.x > 0:
		
		# Redefinindo o sentido horizontal original da imagem.
		
		imagem_inimigo.flip_h = false
		
	elif sentido_movimento.x < 0:
		
		# Espelhando a imagem.
		
		imagem_inimigo.flip_h = true
