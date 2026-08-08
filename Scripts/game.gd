extends Node2D

const PIXELS_PER_METER := 50.0

var kills := 0
var coins := 0
var elapsed_time := 0.0
var max_distance := 0.0

@onready var player: Node2D = get_tree().get_first_node_in_group("player")
@onready var start_x: float = player.global_position.x

func _process(delta: float) -> void:
	elapsed_time += delta
	var distance := (player.global_position.x - start_x) / PIXELS_PER_METER
	max_distance = max(max_distance, distance)

func add_kill(coin_reward: int = 1) -> void:
	kills += 1
	coins += coin_reward
