extends Area2D

# Disco do Discobolo: vai ate a distancia maxima e retorna ao jogador,
# atingindo inimigos na ida e na volta

const SPEED := 400.0

var direction := Vector2.RIGHT
var damage := 3
var max_distance := 400.0
var traveled := 0.0
var returning := false
var player: Node = null
var hit_enemies: Array = []

func _ready() -> void:
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	var step := SPEED * delta
	if not returning:
		position += direction * step
		traveled += step
		if traveled >= max_distance:
			returning = true
			hit_enemies.clear()  # na volta, pode atingir de novo
	else:
		if player == null or not is_instance_valid(player):
			queue_free()
			return
		var dir := global_position.direction_to(player.global_position)
		position += dir * step
		rotation = dir.angle()
		if global_position.distance_to(player.global_position) < 20.0:
			queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies") and body not in hit_enemies:
		hit_enemies.append(body)
		body.take_damage(damage)
