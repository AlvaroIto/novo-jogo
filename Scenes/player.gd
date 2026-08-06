extends CharacterBody2D

const SPEED := 300.0

func _ready() -> void:
	add_to_group("player")

func _physics_process(_delta):
	var direction := Input.get_axis("ui_left", "ui_right")

	velocity.x = direction * SPEED
	velocity.y = 0

	move_and_slide()
