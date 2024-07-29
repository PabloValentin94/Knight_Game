extends Node2D

@export var valor_dano: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	%Valor_Dano.text = str(valor_dano)
