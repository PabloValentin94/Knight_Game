extends Node2D

@onready var area_alcance_especial: Area2D = $Area_Alcance_Especial

@export var qnt_dano: int = 1

func Apply_Damage() -> void:
	
	var corpos = area_alcance_especial.get_overlapping_bodies()
	
	for corpo in corpos:
		
		if corpo.is_in_group("Inimigos"):
			
			var inimigo: Enemy = corpo
			
			inimigo.Suffer_Damage(qnt_dano)
