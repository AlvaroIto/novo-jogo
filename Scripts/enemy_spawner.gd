extends Node2D

const ENEMY_SCENE := preload("res://Scenes/enemy.tscn")
const SPAWN_INTERVAL := 2.0
const SPAWN_DISTANCE := 400.0

@onready var player: Node2D = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	var timer := Timer.new()
	timer.wait_time = SPAWN_INTERVAL
	timer.autostart = true
	timer.timeout.connect(_spawn_enemy)
	add_child(timer)

func _spawn_enemy() -> void:
	if player == null:
		return
	var enemy := ENEMY_SCENE.instantiate()
	var angle := randf() * TAU
	enemy.global_position = player.global_position + Vector2.from_angle(angle) * SPAWN_DISTANCE
	add_child(enemy)
