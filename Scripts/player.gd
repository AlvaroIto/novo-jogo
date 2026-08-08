extends CharacterBody2D

const PROJECTILE_SCENE := preload("res://Scenes/projectile.tscn")

var max_health := 100
var health := 100
var invincible := false
var speed := 300.0
var shoot_interval := 1.0
var shoot_timer: Timer
var xp := 0
var level := 1
var xp_to_next_level := 5
var min_x := 0.0
var projectile_damage := 1
var pierce_chance := 0.0
var multi_chance := 0.0
var slash_damage := 3
var slash_interval := 1.5
var slash_range := 130.0
var slash_timer: Timer

func _ready() -> void:
	add_to_group("player")
	max_health += GameData.upgrade_health * 10
	health = max_health
	projectile_damage += GameData.upgrade_damage
	speed *= 1.0 + GameData.upgrade_speed * 0.05
	min_x = global_position.x
	shoot_timer = Timer.new()
	shoot_timer.wait_time = shoot_interval
	shoot_timer.autostart = true
	shoot_timer.timeout.connect(_shoot)
	add_child(shoot_timer)
	slash_timer = Timer.new()
	slash_timer.wait_time = slash_interval
	slash_timer.autostart = true
	slash_timer.timeout.connect(_slash)
	add_child(slash_timer)

func _physics_process(_delta):
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed
	velocity.y = 0
	move_and_slide()

	for i in get_slide_collision_count():
		var body := get_slide_collision(i).get_collider()
		if body.is_in_group("enemies"):
			_take_damage(10)

	if global_position.x < min_x:
		global_position.x = min_x

func _take_damage(amount: int) -> void:
	if invincible:
		return
	health -= amount
	if health <= 0:
		_game_over()
		return
	invincible = true
	modulate = Color(1, 0.3, 0.3)
	await get_tree().create_timer(1.0).timeout
	modulate = Color(1, 1, 1)
	invincible = false

func _game_over() -> void:
	get_tree().current_scene.get_node("UI").show_game_over()

func _shoot() -> void:
	var enemy := _get_nearest_enemy()
	if enemy == null:
		return
	var direction := global_position.direction_to(enemy.global_position)
	_spawn_projectile(direction)
	if randf() < multi_chance:
		_spawn_projectile(direction.rotated(0.3))

func _spawn_projectile(direction: Vector2) -> void:
	var projectile := PROJECTILE_SCENE.instantiate()
	projectile.global_position = global_position
	projectile.direction = direction
	projectile.damage = projectile_damage
	projectile.pierce = 1 if randf() < pierce_chance else 0
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

func gain_xp(amount: int) -> void:
	xp += amount
	if xp >= xp_to_next_level:
		xp -= xp_to_next_level
		level += 1
		xp_to_next_level += 3
		get_tree().current_scene.get_node("UI").show_level_up()

func _slash() -> void:
	var enemies := get_tree().get_nodes_in_group("enemies")
	var hit_any := false
	for enemy in enemies:
		if global_position.distance_to(enemy.global_position) <= slash_range:
			enemy.take_damage(slash_damage)
			hit_any = true
	if hit_any:
		_show_slash_effect()

func _show_slash_effect() -> void:
	var sprite := Sprite2D.new()
	sprite.texture = preload("res://icon.svg")
	sprite.modulate = Color(1, 1, 1, 0.6)
	sprite.scale = Vector2(0.3, 0.3)
	sprite.z_index = 1
	sprite.global_position = global_position
	get_tree().current_scene.add_child(sprite)
	var tween := sprite.create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "scale", Vector2(2.2, 2.2), 0.2)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.2)
	tween.chain().tween_callback(sprite.queue_free)

func apply_upgrade(key: String) -> void:
	match key:
		"health":
			max_health += 20
			health = min(health + 20, max_health)
		"speed":
			speed *= 1.1
		"attack_speed":
			shoot_interval *= 0.85
			shoot_timer.wait_time = shoot_interval
		"damage":
			projectile_damage += 1
		"pierce":
			pierce_chance += 0.25
		"multi":
			multi_chance += 0.20
