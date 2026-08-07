extends CharacterBody2D

const SPEED := 300.0
const PROJECTILE_SCENE := preload("res://Scenes/projectile.tscn")
const SHOOT_INTERVAL := 1.0

var health := 100
var invincible := false

func _ready() -> void:
	add_to_group("player")
	var timer := Timer.new()
	timer.wait_time = SHOOT_INTERVAL
	timer.autostart = true
	timer.timeout.connect(_shoot)
	add_child(timer)

func _physics_process(_delta):
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED
	velocity.y = 0
	move_and_slide()

	for i in get_slide_collision_count():
		var body := get_slide_collision(i).get_collider()
		if body.is_in_group("enemies"):
			_take_damage(10)

func _take_damage(amount: int) -> void:
	if invincible:
		return
	health -= amount
	print("Vida do jogador: ", health)
	if health <= 0:
		_game_over()
		return
	invincible = true
	modulate = Color(1, 0.3, 0.3)  # deixa o jogador avermelhado
	await get_tree().create_timer(1.0).timeout
	modulate = Color(1, 1, 1)
	invincible = false

func _shoot() -> void:
	var enemy := _get_nearest_enemy()
	if enemy == null:
		return
	var projectile := PROJECTILE_SCENE.instantiate()
	projectile.global_position = global_position
	projectile.direction = global_position.direction_to(enemy.global_position)
	get_tree().current_scene.get_node("Projectiles").add_child(projectile)

func _get_nearest_enemy() -> Node2D:
	var enemies := get_tree().get_nodes_in_group("enemies")
	var nearest: Node2D = null
	var nearest_distance := INF
	for enemy in enemies:
		var distance := global_position.distance_to(enemy.global_position)
		if distance < nearest_distance:
			nearest = enemy
			nearest_distance = distance
	return nearest

func _game_over() -> void:
	get_tree().current_scene.get_node("UI").show_game_over()
