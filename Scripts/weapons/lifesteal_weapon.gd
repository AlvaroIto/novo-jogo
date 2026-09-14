extends Node2D

# Sede de Sangue: arma defensiva passiva — 5% do dano causado vira vida

func _ready() -> void:
	var player = get_parent()
	player.lifesteal += 0.05
	add_to_group("weapons")

func update_interval() -> void:
	pass
