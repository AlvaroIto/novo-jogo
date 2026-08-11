extends CharacterBody2D

const XP_GEM_SCENE := preload("res://Scenes/xp_gem.tscn")
const ARROW_SCENE := preload("res://Scenes/enemy_arrow.tscn")

var speed := 150.0
var health := 2
var coin_value := 1
var gem_count := 1
var is_final_boss := false
var base_modulate := Color(1, 1, 1)
var explosive := false
var archer := false
var arrow_timer: Timer
var sprite_texture: Texture2D = null

@onready var player: Node2D = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	add_to_group("enemies")
	base_modulate = modulate
	if sprite_texture != null:
		$Sprite2D.texture = sprite_texture
		$Sprite2D.scale = Vector2(0.35, 0.35)
		$Sprite2D.flip_h = true
	if archer:
		arrow_timer = Timer.new()
		arrow_timer.wait_time = 2.5
		arrow_timer.autostart = true
		arrow_timer.timeout.connect(_shoot_arrow)
		add_child(arrow_timer)

func _physics_process(_delta: float) -> void:
	if player == null:
		return
	var distance := global_position.distance_to(player.global_position)
	if explosive and distance < 50.0:
		_explode()
		return
	if archer and distance <= 300.0:
		velocity = Vector2.ZERO
	else:
		velocity = global_position.direction_to(player.global_position) * speed
	move_and_slide()

func _explode() -> void:
	if player != null:
		player._take_damage(15)
	queue_free()

func _shoot_arrow() -> void:
	if player == null:
		return
	var arrow := ARROW_SCENE.instantiate()
	arrow.global_position = global_position
	arrow.direction = global_position.direction_to(player.global_position)
	get_parent().add_child(arrow)

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
