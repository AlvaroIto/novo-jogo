extends Node2D

const ENEMY_SCENE := preload("res://Scenes/enemy.tscn")
const SPAWN_INTERVAL := 2.0
const MIN_INTERVAL := 0.5
const SPAWN_DISTANCE := 650.0
const SPAWN_Y_RANGE := 350.0

var current_interval := SPAWN_INTERVAL
var timer: Timer
var mini_boss_spawned := false
var boss_spawned := false

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
	# nascem na linha do chão ou acima dela, nunca abaixo
	var offset_y := randf_range(-SPAWN_Y_RANGE, 0.0)
	enemy.global_position = player.global_position + Vector2(SPAWN_DISTANCE, offset_y)

	var roll := randf()
	if roll < 0.15:
		# tanque: lento, resistente, vale mais moedas
		enemy.speed = 70.0
		enemy.health = 6
		enemy.coin_value = 5
		enemy.scale = Vector2(1.5, 1.5)
		enemy.modulate = Color(1, 0.4, 0.4)
	elif roll < 0.45:
		# rapido: fraco, veloz, vale 2 moedas
		enemy.speed = 280.0
		enemy.health = 1
		enemy.coin_value = 2
		enemy.scale = Vector2(0.8, 0.8)
		enemy.modulate = Color(0.5, 0.8, 1)

	add_child(enemy)

	# a cada spawn, o intervalo diminui 0.02s até o mínimo de 0.5s
	current_interval = max(MIN_INTERVAL, current_interval - 0.02)
	timer.wait_time = current_interval

func _process(_delta: float) -> void:
	var game := get_tree().current_scene
	if not mini_boss_spawned and game.max_distance >= 250.0:
		mini_boss_spawned = true
		_spawn_boss(20, Color(0.7, 0.3, 1), 25)  # mini-boss roxo
	elif not boss_spawned and game.max_distance >= 500.0:
		boss_spawned = true
		_spawn_boss(50, Color(1, 0.85, 0.2), 50, true)  # boss final dourado

func _spawn_boss(hp: int, color: Color, coins: int, is_final := false) -> void:
	if player == null:
		return
	var boss := ENEMY_SCENE.instantiate()
	boss.global_position = player.global_position + Vector2(SPAWN_DISTANCE, 0)
	boss.speed = 50.0
	boss.health = hp
	boss.coin_value = coins
	boss.gem_count = 5
	boss.scale = Vector2(2.5, 2.5)
	boss.modulate = color
	boss.is_final_boss = is_final
	add_child(boss)
	print("Um chefe apareceu!")
