extends Node2D

const ENEMY_SCENE := preload("res://Scenes/enemy.tscn")
const SPAWN_INTERVAL := 2.0
const MIN_INTERVAL := 0.5
const SPAWN_DISTANCE := 400.0

var current_interval := SPAWN_INTERVAL
var timer: Timer

@onready var player: Node2D = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = current_interval
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

	# a cada spawn, o intervalo diminui 0.02s até o mínimo de 0.5s
	current_interval = max(MIN_INTERVAL, current_interval - 0.02)
	timer.wait_time = current_interval
