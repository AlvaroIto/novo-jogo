extends Area2D

# Escudo Orbital: gira ao redor do jogador, danifica e empurra inimigos

var player: Node
var angle := 0.0
var radius := 70.0
var orbit_speed := 3.0
var damage := 5

func _ready() -> void:
	player = get_parent()
	add_to_group("weapons")
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	angle += orbit_speed * delta
	position = Vector2(radius, 0).rotated(angle)

func update_interval() -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(int(damage * player.get_damage_multiplier()))
		var dir: Vector2 = player.global_position.direction_to(body.global_position)
		body.global_position += dir * 40.0  # empurrao
