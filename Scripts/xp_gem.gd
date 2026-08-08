extends Area2D

const VALUE := 1
const SPEED := 400.0

@onready var player: Node2D = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	if player == null:
		return
	global_position = global_position.move_toward(player.global_position, SPEED * delta)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.gain_xp(VALUE)
		queue_free()
