extends CharacterBody2D

@onready var quadro_animacoes: AnimationPlayer = $Animacoes

var animacoes: Array = ["Esperar","Correr","Atacar_Para_Frente_01",
"Atacar_Para_Frente_02","Atacar_Para_Baixo_01","Atacar_Para_Baixo_02",
"Atacar_Para_Cima_01","Atacar_Para_Cima_02"]

var indice_animacao: int = 0

func _ready() -> void:
	
	quadro_animacoes.play(animacoes[0])

func _process(_delta) -> void:
	
	if Input.is_action_just_pressed("ui_accept"):
		
		if(indice_animacao + 1 <= 7):
			
			indice_animacao += 1
			
		else:
			
			indice_animacao = 0
			
		quadro_animacoes.play(animacoes[indice_animacao])
