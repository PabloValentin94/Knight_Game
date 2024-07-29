extends Node2D

@export var taxa_regeneracao: int = 5

func _ready() -> void:
	
	# Fazendo com que a função "Invaded_Area" seja executada toda vez
	# que o evento "Area2D.body_entered" ocorrer.
	
	$Area_Surgimento.body_entered.connect(Invaded_Area)

func Invaded_Area(body: Node2D) -> void:
	
	if body.is_in_group("Jogador"):
		
		var player: Player = body
		
		player.Heal(taxa_regeneracao)
		
		# player.Meat_Collected.emit(taxa_regeneracao)
		player.Meat_Collected.emit()
	
		queue_free()
