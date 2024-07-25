class_name Enemy extends Node2D

@export_range(1,100) var vida_inimigo:int = 10

func Suffer_Damage(dano: int) -> String:

	vida_inimigo -= dano
	
	return str("Dano sofrido: ", dano, ". Vida atual do inimigo: ", vida_inimigo)
