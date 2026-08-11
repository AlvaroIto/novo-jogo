extends Area2D

const SPEED := 150.0

var direction := Vector2.LEFT

func _ready() -> void:
	add_to_group("enemy_projectiles")
	rotation = direction.angle()
	var timer := Timer.new()
	timer.wait_time = 5.0
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(queue_free)
	add_child(timer)

func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body._take_damage(5)
		queue_free()
