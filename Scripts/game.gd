extends Node2D

var kills := 0
var elapsed_time := 0.0

func _process(delta: float) -> void:
	elapsed_time += delta

func add_kill() -> void:
	kills += 1
