extends CharacterBody2D

const WEAPON_SCENES := {
	"projectile": preload("res://Scenes/weapons/projectile_weapon.tscn"),
	"slash": preload("res://Scenes/weapons/slash_weapon.tscn"),
	"aura": preload("res://Scenes/weapons/aura_weapon.tscn"),
}

# sprites por classe (adicionar viking/espartano quando a arte chegar)
const CLASS_SPRITES := {
	"samurai": preload("res://Sprites/player_samurai.png"),
}
const CLASS_SPRITE_SCALE := Vector2(0.5, 0.5)

var max_health := 100
var health := 100
var invincible := false
var speed := 300.0
var min_x := 0.0
var xp := 0
var level := 1
var xp_to_next_level := 5

# stats das armas
var projectile_damage := 1
var pierce_chance := 0.0
var multi_chance := 0.0
var double_attack_chance := 0.0
var shoot_interval := 1.0
var slash_damage := 3
var slash_interval := 1.5
var slash_range := 130.0
var aura_damage := 1
var aura_interval := 0.5

var berserker := false
var weapon_keys: Array = []

func _ready() -> void:
	add_to_group("player")
	_apply_camp_upgrades()
	_apply_class(GameData.selected_class)
	min_x = global_position.x

func _apply_camp_upgrades() -> void:
	max_health += GameData.upgrade_health * 10
	health = max_health
	projectile_damage += GameData.upgrade_damage
	speed *= 1.0 + GameData.upgrade_speed * 0.05

func _apply_class(class_key: String) -> void:
	var data: Dictionary = GameData.CLASSES[class_key]
	match data.passive:
		"attack_speed":
			shoot_interval /= 1.1
			slash_interval /= 1.1
			aura_interval /= 1.1
		"berserker":
			berserker = true
		"projectile_damage":
			projectile_damage += 1
	var weapon: Node = WEAPON_SCENES[data.weapon].instantiate()
	add_child(weapon)
	weapon_keys.append(data.weapon)
	if CLASS_SPRITES.has(class_key):
		$Sprite2D.texture = CLASS_SPRITES[class_key]
		$Sprite2D.scale = CLASS_SPRITE_SCALE

func get_damage_multiplier() -> float:
	if not berserker:
		return 1.0
	var missing := 1.0 - float(health) / float(max_health)
	return 1.0 + missing * 0.5

func _physics_process(_delta):
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * speed
	velocity.y = 0
	move_and_slide()

	for i in get_slide_collision_count():
		var body := get_slide_collision(i).get_collider()
		if body.is_in_group("enemies"):
			_take_damage(10)

	if global_position.x < min_x:
		global_position.x = min_x

func _take_damage(amount: int) -> void:
	if invincible:
		return
	health -= amount
	if health <= 0:
		_game_over()
		return
	invincible = true
	modulate = Color(1, 0.3, 0.3)
	await get_tree().create_timer(1.0).timeout
	modulate = Color(1, 1, 1)
	invincible = false

func _game_over() -> void:
	get_tree().current_scene.get_node("UI").show_game_over()

func gain_xp(amount: int) -> void:
	xp += amount
	if xp >= xp_to_next_level:
		xp -= xp_to_next_level
		level += 1
		xp_to_next_level += 3
		get_tree().current_scene.get_node("UI").show_level_up()

func apply_upgrade(key: String) -> void:
	match key:
		"health":
			max_health += 20
			health = min(health + 20, max_health)
		"speed":
			speed *= 1.1
		"attack_speed":
			shoot_interval *= 0.85
			slash_interval *= 0.85
			aura_interval *= 0.85
			for weapon in get_tree().get_nodes_in_group("weapons"):
				weapon.update_interval()
		"damage":
			projectile_damage += 1
			slash_damage += 1
			aura_damage += 1
		"special_a":
			if "projectile" in weapon_keys:
				pierce_chance += 0.25
			else:
				for weapon in get_tree().get_nodes_in_group("weapons"):
					if weapon.has_method("apply_range_bonus"):
						weapon.apply_range_bonus(1.25)
		"special_b":
			if "projectile" in weapon_keys:
				multi_chance += 0.20
			else:
				double_attack_chance += 0.20
