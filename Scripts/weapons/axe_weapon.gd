extends Node2D

# Machado Pesado: corte em area mais lento e forte que a katana
const ICON := preload("res://Sprites/heavy_axe_slash.png")

var player: Node
var timer: Timer

func _ready() -> void:
	player = get_parent()
	add_to_group("weapons")
	timer = Timer.new()
	timer.wait_time = player.axe_interval
	timer.autostart = true
	timer.timeout.connect(_strike)
	add_child(timer)

func update_interval() -> void:
	timer.wait_time = player.axe_interval

func apply_range_bonus(factor: float) -> void:
	player.axe_range *= factor

func _strike() -> void:
	_hit()
	if randf() < player.double_attack_chance:
		_hit()

func _hit() -> void:
	var enemies := get_tree().get_nodes_in_group("enemies")
	var hit_any := false
	var damage := int(player.axe_damage * player.get_damage_multiplier())
	for enemy in enemies:
		if player.global_position.distance_to(enemy.global_position) <= player.axe_range:
			enemy.take_damage(damage)
			hit_any = true
	if hit_any:
		_show_effect()

func _show_effect() -> void:
	var sprite := Sprite2D.new()
	sprite.texture = ICON
	sprite.rotation = randf() * TAU
	sprite.scale = Vector2(0.08, 0.08)
	sprite.z_index = 1
	sprite.global_position = player.global_position
	get_tree().current_scene.add_child(sprite)
	var tween := sprite.create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "scale", Vector2(0.25, 0.25), 0.2)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.2)
	tween.chain().tween_callback(sprite.queue_free)
