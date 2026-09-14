extends Node2D

# Formação de Lanças: fileira de lanças atinge a frente do jogador
const ICON := preload("res://Sprites/spear_formation.png")

var player: Node
var timer: Timer

func _ready() -> void:
	player = get_parent()
	add_to_group("weapons")
	timer = Timer.new()
	timer.wait_time = player.spear_interval
	timer.autostart = true
	timer.timeout.connect(_strike)
	add_child(timer)

func update_interval() -> void:
	timer.wait_time = player.spear_interval

func apply_range_bonus(factor: float) -> void:
	player.spear_range *= factor

func _strike() -> void:
	_hit()
	if randf() < player.double_attack_chance:
		_hit()

func _hit() -> void:
	var enemies := get_tree().get_nodes_in_group("enemies")
	var hit_any := false
	var damage := int(player.spear_damage * player.get_damage_multiplier())
	for enemy in enemies:
		var diff: Vector2 = enemy.global_position - player.global_position
		if diff.length() <= player.spear_range and diff.x > -20.0:
			enemy.take_damage(damage)
			hit_any = true
	if hit_any:
		_show_effect()

func _show_effect() -> void:
	var sprite := Sprite2D.new()
	sprite.texture = ICON
	sprite.scale = Vector2(0.1, 0.1)
	sprite.z_index = 1
	sprite.global_position = player.global_position + Vector2(120, 0)
	get_tree().current_scene.add_child(sprite)
	var tween := sprite.create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "scale", Vector2(0.15, 0.15), 0.2)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.2)
	tween.chain().tween_callback(sprite.queue_free)
