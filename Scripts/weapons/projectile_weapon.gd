extends Node2D

const PROJECTILE_SCENE := preload("res://Scenes/projectile.tscn")

var player: Node
var timer: Timer

func _ready() -> void:
	player = get_parent()
	add_to_group("weapons")
	timer = Timer.new()
	timer.wait_time = player.shoot_interval
	timer.autostart = true
	timer.timeout.connect(_shoot)
	add_child(timer)

func update_interval() -> void:
	timer.wait_time = player.shoot_interval

func _shoot() -> void:
	var enemy := _get_nearest_enemy()
	if enemy == null:
		return
	var direction: Vector2 = player.global_position.direction_to(enemy.global_position)
	_spawn(direction)
	if randf() < player.multi_chance:
		_spawn(direction.rotated(0.3))

func _spawn(direction: Vector2) -> void:
	var projectile := PROJECTILE_SCENE.instantiate()
	projectile.global_position = player.global_position
	projectile.direction = direction
	projectile.damage = int(player.projectile_damage * player.get_damage_multiplier())
	projectile.pierce = 1 if randf() < player.pierce_chance else 0
	get_tree().current_scene.get_node("Projectiles").add_child(projectile)

func _get_nearest_enemy() -> Node2D:
	var enemies := get_tree().get_nodes_in_group("enemies")
	var nearest: Node2D = null
	var nearest_distance := INF
	for enemy in enemies:
		var distance: float = player.global_position.distance_to(enemy.global_position)
		if distance < nearest_distance:
			nearest = enemy
			nearest_distance = distance
	return nearest
