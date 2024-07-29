class_name Player extends CharacterBody2D

@export_category("Game Definitions")

# var indice_animacao: int = 0

@export var deadzone_controle: float = 0.15

var intervalo_processamento_dano: float = 0.5

var timer_processamento_dano: float = 0

@export_category("Animations Definitions")

@export var animacoes: Array[String] = ["Esperar", "Correr", "Atacar_Para_Frente_01",
"Atacar_Para_Frente_02", "Atacar_Para_Baixo_01", "Atacar_Para_Baixo_02",
"Atacar_Para_Cima_01", "Atacar_Para_Cima_02"]

@export_category("Player Definitions")

@export_range(1,10) var velocidade_movimento: float = 3

const vida_maxima_player:int = 100

@export_range(1,vida_maxima_player) var vida_player:int = 50

@export var qnt_dano_ataque_normal: int = 2

var timer_ataque: float = 0.6

var condicao_ataque: bool = false

@export var evento_morte: PackedScene

@export_category("Special Attack Definitions")

@export var qnt_dano_ataque_especial: int = 1

@export var intervalo_surgimento_ataque_especial: float = 10

var timer_surgimento_ataque_especial: float = 0

@export var evento_ataque_especial: PackedScene

var direcoes: Vector2 = Vector2(0,0)

@onready var barra_vida: ProgressBar = $Barra_Vida

@onready var imagem_player: Sprite2D = $Corpo/Imagem

@onready var area_alcance_ataque: Area2D = $Area_Alcance_Ataques

@onready var area_dano: Area2D = $Area_Dano

@onready var quadro_animacoes: AnimationPlayer = $Animacoes

# Um Signal é um recurso parecido com uma função e que possui alcance
# global, ou seja, está disponível em todo o projeto.

# signal Meat_Collected(valor_restaurado_vida: int)
signal Meat_Collected()

func _ready() -> void:
	
	barra_vida.max_value = vida_maxima_player
	
	barra_vida.value = vida_player
	
	Global.player = self

func _process(delta: float) -> void:
	
	# Atualizando o valor da variável global relacionada ao player.
	
	Global.coordenadas_player = position
	
	Define_Directions()
	
	if condicao_ataque:
		
		timer_ataque -= delta
	
		if timer_ataque <= 0:
		
			condicao_ataque = false
			
	Damage_Hitbox_Verification(delta)
	
	Active_Special_Attack(delta)

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
				
				inimigo.Suffer_Damage(qnt_dano_ataque_normal)
				
func Damage_Hitbox_Verification(delta: float) -> void:
	
	timer_processamento_dano -= delta
	
	if timer_processamento_dano <= 0:
		
		timer_processamento_dano = intervalo_processamento_dano
	
		if vida_player > 0:
		
			var corpos: Array[Node2D] = area_dano.get_overlapping_bodies()
			
			for corpo in corpos:
				
				if corpo.is_in_group("Inimigos"):
					
					Suffer_Damage(2)
				
func Suffer_Damage(dano: int) -> void:
	
	vida_player -= dano
	
	barra_vida.value -= dano
	
	print("Dano sofrido: ", dano, ". Vida atual do player: ", vida_player, "\n")
	
	modulate = Color.RED
	
	var efeito_tween = create_tween()
	
	efeito_tween.set_ease(Tween.EASE_IN)
	
	efeito_tween.set_trans(Tween.TRANS_QUINT)
	
	efeito_tween.tween_property(self, "modulate", Color.WHITE, 0.25)
	
	if vida_player <= 0:
		
		Die()

func Die() -> void:
	
	if evento_morte:
		
		var morte = evento_morte.instantiate()
		
		morte.position = position
		
		get_parent().add_child(morte)
		
	queue_free()

func Heal(regeneracao: int) -> void:
	
	print("Vida antes da cura: ", vida_player, "\n")
	
	vida_player += regeneracao
	
	barra_vida.value += regeneracao
	
	if vida_player > vida_maxima_player:
		
		vida_player = vida_maxima_player
		
	print("Vida após a cura: ", vida_player, "\n")
	
func Active_Special_Attack(delta: float) -> void:
	
	timer_surgimento_ataque_especial -= delta
	
	if timer_surgimento_ataque_especial <= 0:
		
		timer_surgimento_ataque_especial = intervalo_surgimento_ataque_especial
		
		var ataque_especial: Node = evento_ataque_especial.instantiate()
		
		ataque_especial.qnt_dano = qnt_dano_ataque_especial
		
		add_child(ataque_especial)
