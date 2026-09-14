extends Node2D

# Escudo de Bronze: arma defensiva passiva — reduz 20% do dano recebido

func _ready() -> void:
	var player = get_parent()
	player.damage_reduction = min(player.damage_reduction + 0.20, 0.8)
	add_to_group("weapons")

func update_interval() -> void:
	pass
