extends CharacterBody2D

const XP_GEM_SCENE := preload("res://Scenes/xp_gem.tscn")

var speed := 150.0
var health := 2
var coin_value := 1
var gem_count := 1
var is_final_boss := false
var base_modulate := Color(1, 1, 1)

@onready var player: Node2D = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	add_to_group("enemies")
	base_modulate = modulate

func _physics_process(_delta: float) -> void:
	if player == null:
		return
	velocity = global_position.direction_to(player.global_position) * speed
	move_and_slide()

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()
		return
	modulate = Color(3, 3, 3)
	await get_tree().create_timer(0.1).timeout
	modulate = base_modulate

func die() -> void:
	for i in gem_count:
		var gem := XP_GEM_SCENE.instantiate()
		var offset := Vector2(randf_range(-40.0, 40.0), randf_range(-40.0, 40.0))
		gem.global_position = global_position + offset
		get_parent().call_deferred("add_child", gem)
	get_tree().current_scene.add_kill(coin_value)
	if is_final_boss:
		get_tree().current_scene.get_node("UI").show_victory()
	queue_free()
