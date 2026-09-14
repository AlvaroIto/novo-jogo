extends Node2D

# Discobolo: lanca o disco bumerangue a cada intervalo
const DISC_SCENE := preload("res://Scenes/weapons/discobolus_disc.tscn")

var player: Node
var timer: Timer

func _ready() -> void:
	player = get_parent()
	add_to_group("weapons")
	timer = Timer.new()
	timer.wait_time = player.disc_interval
	timer.autostart = true
	timer.timeout.connect(_throw)
	add_child(timer)

func update_interval() -> void:
	timer.wait_time = player.disc_interval

func _throw() -> void:
	var enemy := _get_nearest_enemy()
	if enemy == null:
		return
	var disc := DISC_SCENE.instantiate()
	disc.global_position = player.global_position
	disc.direction = player.global_position.direction_to(enemy.global_position)
	disc.damage = int(player.disc_damage * player.get_damage_multiplier())
	disc.player = player
	get_tree().current_scene.get_node("Projectiles").add_child(disc)

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
