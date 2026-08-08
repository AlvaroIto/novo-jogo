extends Area2D

var damage := 1
var tick_interval := 0.5

func _ready() -> void:
	var timer := Timer.new()
	timer.wait_time = tick_interval
	timer.autostart = true
	timer.timeout.connect(_deal_damage)
	add_child(timer)

func _deal_damage() -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("enemies"):
			body.take_damage(damage)
