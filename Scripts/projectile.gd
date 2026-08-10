extends Area2D

const SPEED := 500.0

var direction := Vector2.RIGHT
var damage := 1
var pierce := 0

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	position += direction * SPEED * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_projectiles"):
		area.queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(damage)
		if pierce > 0:
			pierce -= 1
		else:
			queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
