extends Area2D

var player: Node
var timer: Timer

func _ready() -> void:
	player = get_parent()
	add_to_group("weapons")
	timer = Timer.new()
	timer.wait_time = player.aura_interval
	timer.autostart = true
	timer.timeout.connect(_deal_damage)
	add_child(timer)

func update_interval() -> void:
	timer.wait_time = player.aura_interval

func apply_range_bonus(factor: float) -> void:
	scale *= factor

func _deal_damage() -> void:
	_tick()
	if randf() < player.double_attack_chance:
		_tick()

func _tick() -> void:
	var damage := int(player.aura_damage * player.get_damage_multiplier())
	for body in get_overlapping_bodies():
		if body.is_in_group("enemies"):
			body.take_damage(damage)
