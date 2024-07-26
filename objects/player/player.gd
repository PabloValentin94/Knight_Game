extends CharacterBody2D

var direcoes: Vector2 = Vector2(0,0)

@export_range(1,10) var velocidade_movimento: float = 3

@onready var quadro_animacoes: AnimationPlayer = $Animacoes

const animacoes: Array[String] = ["Esperar", "Correr", "Atacar_Para_Frente_01",
"Atacar_Para_Frente_02", "Atacar_Para_Baixo_01", "Atacar_Para_Baixo_02",
"Atacar_Para_Cima_01", "Atacar_Para_Cima_02"]

# var indice_animacao: int = 0

@onready var imagem_player: Sprite2D = $Corpo/Imagem

const deadzone_controle = 0.15

var timer_ataque: float = 0.6

var condicao_ataque: bool = false

@onready var area_alcance_ataque: Area2D = $Alcance_Ataques

var qnt_dano: int = 2

func _process(delta: float) -> void:
	
	# Atualizando o valor da variável global relacionada ao player.
	
	Global.coordenadas_player = position
	
	Define_Directions()
	
	if condicao_ataque:
		
		timer_ataque -= delta
	
		if timer_ataque <= 0:
		
			condicao_ataque = false

func _physics_process(_delta: float) -> void:
	
	# Definindo uma velocidade adequada de movimento.
	
	var target_speed = direcoes * (velocidade_movimento * 100)
	
	if condicao_ataque: target_speed *= 0.25
	
	# Usando a função LERP para criar um efeito de fluidez de movimento.
	
	velocity = lerp(velocity, target_speed, 0.05)
	
	# Função interna do Godot responsável pela movimentação e aplicação
	# da física do corpo do personagem.
	
	move_and_slide()
	
	Move_Player()
	
	if Input.is_action_just_pressed("Attack"):
		
		Player_Attack()
		
func Define_Directions() -> void:
	
	# Obtendo os índices que determinam a direção para qual o personagem está indo.

	direcoes = Input.get_vector("Move_to_Left", "Move_to_Right", "Move_to_Up", "Move_to_Down")
	
	# Anulando a deadzone de controles com joysticks (Analógicos).
	
	# Anulando a deadzone horizontal.
	
	if abs(direcoes.x) < deadzone_controle: direcoes.x = 0
	
	# Anulando a deadzone vertical.
	
	if abs(direcoes.y) < deadzone_controle: direcoes.y = 0

func Move_Player() -> void:
	
	if not condicao_ataque:
	
		if not direcoes.is_zero_approx():
			
			# Aplicando animação de corrida.
			
			quadro_animacoes.play(animacoes[1])
			
			Mirror_Image()
			
		else:
			
			# Aplicando animação de espera.
			
			quadro_animacoes.play(animacoes[0])
		
func Mirror_Image() -> void:
	
	# Verificando o sentido horizontal para qual o personagem está correndo.
		
	if direcoes.x > 0:
		
		# Redefinindo o sentido horizontal original da imagem.
		
		imagem_player.flip_h = false
		
	elif direcoes.x < 0:
		
		# Espelhando a imagem.
		
		imagem_player.flip_h = true

func Player_Attack() -> void:
	
	if not condicao_ataque:
		
		timer_ataque = 0.6
		
		# indice_animacao = randi_range(2,7)
		
		quadro_animacoes.play(animacoes[2])
		
		condicao_ataque = true

func Apply_Damage() -> void:
	
	# Determinando se algum inimigo entrou na área de alcance dos ataques.
	
	var corpos: Array[Node2D] = area_alcance_ataque.get_overlapping_bodies()
	
	for corpo in corpos:
		
		if corpo.is_in_group("Inimigos"):
			
			var inimigo: Enemy = corpo
			
			# Determinando se o jogador está de frente para o inimigo.
			
			var perspectiva_player_inimigo = (inimigo.position - position).normalized()
			
			var sentido_ataque: Vector2 = Vector2(0,0)
			
			if imagem_player.flip_h:
				
				sentido_ataque = Vector2.LEFT
				
			else:
				
				sentido_ataque = Vector2.RIGHT
				
			# A variável abaixo determina a perspectiva entre o player e o inimigo,
			# ou seja, o player está de frente para com o inimigo? Está de costas?
			# Se encontra no mesmo ponto do eixo X (Horizontal)? Entre outras coisas.
			
			# Pesquise sobre produto escalar e ciclo trigonométrico para
			# ampliar seu entendimento sobre o assunto.
				
			var produto_escalar = perspectiva_player_inimigo.dot(sentido_ataque)
			
			# print("Valor do Dot Product: ", produto_escalar, "\n")
			
			if produto_escalar >= 0.3:
				
				inimigo.Suffer_Damage(qnt_dano)
