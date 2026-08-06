extends CharacterBody2D

const SPEED := 300.0
const PROJECTILE_SCENE := preload("res://Scenes/projectile.tscn")
const SHOOT_INTERVAL := 1.0

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
