extends Node2D

const ENEMY_SCENE := preload("res://Scenes/enemy.tscn")
const ARCHER_TEX := preload("res://Sprites/enemy_archer.png")
const BOSS_MINI_TEX := preload("res://Sprites/boss_mini.png")
const BOSS_FINAL_TEX := preload("res://Sprites/boss_final.png")
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
	var game := get_tree().current_scene
	var type := _pick_enemy_type(game.max_distance)
	var enemy := ENEMY_SCENE.instantiate()

	# nascem na linha do chão ou acima dela, nunca abaixo
	var offset_y := randf_range(-SPAWN_Y_RANGE, 0.0)
	if type == "tengu":
		offset_y = randf_range(-350.0, -200.0)
	enemy.global_position = player.global_position + Vector2(SPAWN_DISTANCE, offset_y)

	_apply_type(enemy, type)

	# escala suave de HP: +1 a cada 200 m
	enemy.health += int(game.max_distance / 200.0)

	add_child(enemy)

func _pick_enemy_type(distance: float) -> String:
	var roll := randf()
	if distance < 100.0:
		return "normal"
	if distance < 200.0:
		if roll < 0.05:
			return _pick_special()  # gotejamento: novos tipos raros
		return "normal" if roll < 0.72 else "fast"
	if distance < 400.0:
		if roll < 0.35:
			return "normal"
		elif roll < 0.57:
			return "fast"
		elif roll < 0.72:
			return "tank"
		elif roll < 0.82:
			return "tengu"
		elif roll < 0.90:
			return "bomber"
		else:
			return "archer"
	if roll < 0.20:
		return "normal"
	elif roll < 0.40:
		return "fast"
	elif roll < 0.55:
		return "tank"
	elif roll < 0.70:
		return "tengu"
	elif roll < 0.85:
		return "bomber"
	else:
		return "archer"

func _pick_special() -> String:
	var specials := ["tengu", "bomber", "archer"]
	return specials[randi() % specials.size()]

func _apply_type(enemy: Node, type: String) -> void:
	match type:
		"tank":
			enemy.speed = 70.0
			enemy.health = 6
			enemy.coin_value = 5
			enemy.scale = Vector2(1.5, 1.5)
			enemy.modulate = Color(1, 0.4, 0.4)
		"fast":
			enemy.speed = 280.0
			enemy.health = 1
			enemy.coin_value = 2
			enemy.scale = Vector2(0.8, 0.8)
			enemy.modulate = Color(0.5, 0.8, 1)
		"tengu":
			enemy.speed = 220.0
			enemy.health = 1
			enemy.coin_value = 2
			enemy.scale = Vector2(0.9, 0.9)
			enemy.modulate = Color(0.6, 0.4, 1)
		"bomber":
			enemy.speed = 240.0
			enemy.health = 1
			enemy.coin_value = 3
			enemy.modulate = Color(1, 0.6, 0.1)
			enemy.explosive = true
		"archer":
			enemy.speed = 100.0
			enemy.health = 2
			enemy.coin_value = 4
			enemy.modulate = Color(1, 1, 1)
			enemy.sprite_texture = ARCHER_TEX
			enemy.archer = true

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
	boss.sprite_texture = BOSS_FINAL_TEX if is_final else BOSS_MINI_TEX
	boss.is_final_boss = is_final
	add_child(boss)
	print("Um chefe apareceu!")
