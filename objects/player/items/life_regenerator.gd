extends Node2D

@export var taxa_regeneracao: int = 5

func _ready() -> void:
	
	$Area_Surgimento.body_entered.connect(Invaded_Area)

func Invaded_Area(body: Node2D) -> void:
	
	if body.is_in_group("Jogador"):
		
		var player: Player = body
		
		player.Heal(taxa_regeneracao)
	
		queue_free()
