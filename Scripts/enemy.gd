extends CharacterBody2D

const SPEED := 150.0
const XP_GEM_SCENE := preload("res://Scenes/xp_gem.tscn")

@onready var player: Node2D = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	add_to_group("enemies")

func _physics_process(_delta: float) -> void:
	if player == null:
		return
	velocity = global_position.direction_to(player.global_position) * SPEED
	move_and_slide()

func die() -> void:
	var gem := XP_GEM_SCENE.instantiate()
	gem.global_position = global_position
	get_parent().call_deferred("add_child", gem)
	get_tree().current_scene.add_kill()
	queue_free()
