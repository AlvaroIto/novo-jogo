extends Node2D

const ICON := preload("res://icon.svg")

var player: Node
var timer: Timer

func _ready() -> void:
	player = get_parent()
	add_to_group("weapons")
	timer = Timer.new()
	timer.wait_time = player.slash_interval
	timer.autostart = true
	timer.timeout.connect(_slash)
	add_child(timer)

func update_interval() -> void:
	timer.wait_time = player.slash_interval

func apply_range_bonus(factor: float) -> void:
	player.slash_range *= factor

func _slash() -> void:
	_strike()
	if randf() < player.double_attack_chance:
		_strike()

func _strike() -> void:
	var enemies := get_tree().get_nodes_in_group("enemies")
	var hit_any := false
	var damage := int(player.slash_damage * player.get_damage_multiplier())
	for enemy in enemies:
		if player.global_position.distance_to(enemy.global_position) <= player.slash_range:
			enemy.take_damage(damage)
			hit_any = true
	for arrow in get_tree().get_nodes_in_group("enemy_projectiles"):
		if player.global_position.distance_to(arrow.global_position) <= player.slash_range:
			arrow.queue_free()
			hit_any = true
	if hit_any:
		_show_effect()

func _show_effect() -> void:
	var sprite := Sprite2D.new()
	sprite.texture = ICON
	sprite.modulate = Color(1, 1, 1, 0.6)
	sprite.scale = Vector2(0.3, 0.3)
	sprite.z_index = 1
	sprite.global_position = player.global_position
	get_tree().current_scene.add_child(sprite)
	var tween := sprite.create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "scale", Vector2(2.2, 2.2), 0.2)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.2)
	tween.chain().tween_callback(sprite.queue_free)
