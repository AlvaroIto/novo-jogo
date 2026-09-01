extends Node2D

# Postura de Iai: arma defensiva passiva — concede 15% de esquiva

func _ready() -> void:
	var player = get_parent()
	player.dodge_chance += 0.15
	add_to_group("weapons")

func update_interval() -> void:
	pass
