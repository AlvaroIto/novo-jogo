extends CharacterBody2D

const SPEED := 150.0

@onready var player: Node2D = get_tree().get_first_node_in_group("player")

func _physics_process(_delta: float) -> void:
	if player == null:
		return
	velocity = global_position.direction_to(player.global_position) * SPEED
	move_and_slide()
