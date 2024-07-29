class_name Enemy extends Node2D

@export_range(1,100) var vida_inimigo:int = 10

var evento_dano: PackedScene = preload("res://objects/enemies/events/display_damage/display_damage.tscn")

@onready var marcador_dano: Marker2D = $Marcador_Dano

@export var evento_morte: PackedScene

func Suffer_Damage(dano: int) -> void:
	
	if vida_inimigo > 0:
		
		vida_inimigo -= dano
		
		print("Dano sofrido: ", dano, ". Vida atual do inimigo: ", vida_inimigo, "\n")
		
		# Fazendo uma estilização que mostra ao usuário se o ataque acertou o inimigo.
		
		modulate = Color.RED
		
		var efeito_tween = create_tween()
		
		efeito_tween.set_ease(Tween.EASE_IN)
		
		efeito_tween.set_trans(Tween.TRANS_QUINT)
		
		efeito_tween.tween_property(self, "modulate", Color.WHITE, 0.25)
		
		# Veja sobre em: https://easings.net
		
		if evento_dano and marcador_dano:
		
			var numero_dano: Node = evento_dano.instantiate()
			
			numero_dano.valor_dano = dano
			
			numero_dano.position = marcador_dano.position
			
			add_child(numero_dano)
		
		if vida_inimigo <= 0:
			
			Die()

func Die() -> void:
	
	if evento_morte:
		
		var morte = evento_morte.instantiate()
		
		morte.position = position
		
		get_parent().add_child(morte)
		
	queue_free()
