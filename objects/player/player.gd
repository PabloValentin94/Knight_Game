extends CharacterBody2D

@onready var quadro_animacoes: AnimationPlayer = $Animacoes

const animacoes: Array = ["Esperar","Correr","Atacar_Para_Frente_01",
"Atacar_Para_Frente_02","Atacar_Para_Baixo_01","Atacar_Para_Baixo_02",
"Atacar_Para_Cima_01","Atacar_Para_Cima_02"]

var indice_animacao: int = 0

func _ready() -> void:
	
	quadro_animacoes.play(animacoes[0])

func _process(_delta) -> void:
	
	if Input.is_action_just_pressed("Move_to_Down") or Input.is_action_just_pressed("Move_to_Right"):
		
		if(indice_animacao + 1 <= 7):
			
			indice_animacao += 1
			
			quadro_animacoes.play(animacoes[indice_animacao])
		
	elif Input.is_action_just_pressed("Move_to_Up") or Input.is_action_just_pressed("Move_to_Left"):
		
		if(indice_animacao - 1 >= 0):
			
			indice_animacao -= 1
			
			quadro_animacoes.play(animacoes[indice_animacao])
