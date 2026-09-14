extends CharacterBody2D

const WEAPON_SCENES := {
	"projectile": preload("res://Scenes/weapons/projectile_weapon.tscn"),
	"slash": preload("res://Scenes/weapons/slash_weapon.tscn"),
	"aura": preload("res://Scenes/weapons/aura_weapon.tscn"),
	"yumi": preload("res://Scenes/weapons/projectile_weapon.tscn"),
	"naginata": preload("res://Scenes/weapons/naginata_weapon.tscn"),
	"iai": preload("res://Scenes/weapons/iai_weapon.tscn"),
	"axe": preload("res://Scenes/weapons/axe_weapon.tscn"),
	"orbital": preload("res://Scenes/weapons/orbital_weapon.tscn"),
	"lifesteal": preload("res://Scenes/weapons/lifesteal_weapon.tscn"),
	"discobolus": preload("res://Scenes/weapons/discobolus_weapon.tscn"),
}
const MAX_WEAPONS := 4
const YUMI_ARROW := preload("res://Sprites/yumi_arrow.png")
const IAI_FX := preload("res://Sprites/iai_stance.png")
const LIFESTEAL_FX := preload("res://Sprites/lifesteal_fx.png")

# sprites por classe (arte nova é maior, então cada uma tem sua escala)
const CLASS_SPRITES := {
	"samurai": {"texture": preload("res://Sprites/player_samurai.png"), "scale": Vector2(0.5, 0.5)},
	"viking": {"texture": preload("res://Sprites/player_viking.png"), "scale": Vector2(0.15, 0.15)},
	"espartano": {"texture": preload("res://Sprites/player_espartano.png"), "scale": Vector2(0.15, 0.15)},
}

var max_health := 100
var health := 100
var invincible := false
var speed := 200.0
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
var naginata_damage := 4
var naginata_interval := 2.0
var naginata_range := 220.0
var dodge_chance := 0.0
var axe_damage := 8
var axe_interval := 3.0
var axe_range := 150.0
var lifesteal := 0.0
var _lifesteal_pool := 0.0
var disc_damage := 3
var disc_interval := 2.5

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
	add_weapon(data.weapon)
	if CLASS_SPRITES.has(class_key):
		$Sprite2D.texture = CLASS_SPRITES[class_key].texture
		$Sprite2D.scale = CLASS_SPRITES[class_key].scale

func add_weapon(key: String) -> void:
	if weapon_keys.size() >= MAX_WEAPONS or key in weapon_keys:
		return
	var weapon: Node = WEAPON_SCENES[key].instantiate()
	if key == "yumi":
		weapon.projectile_texture = YUMI_ARROW
	add_child(weapon)
	weapon_keys.append(key)

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
	if randf() < dodge_chance:
		_show_dodge_effect()
		return  # esquivou!
	health -= amount
	if health <= 0:
		_game_over()
		return
	invincible = true
	modulate = Color(1, 0.3, 0.3)
	await get_tree().create_timer(1.0).timeout
	modulate = Color(1, 1, 1)
	invincible = false

func _show_dodge_effect() -> void:
	var sprite := Sprite2D.new()
	sprite.texture = IAI_FX
	sprite.scale = Vector2(0.15, 0.15)
	sprite.z_index = 2
	sprite.global_position = global_position
	get_tree().current_scene.add_child(sprite)
	var tween := sprite.create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "scale", Vector2(0.3, 0.3), 0.3)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.3)
	tween.chain().tween_callback(sprite.queue_free)

func heal_from_damage(amount: int) -> void:
	if lifesteal <= 0.0:
		return
	_lifesteal_pool += amount * lifesteal
	if _lifesteal_pool >= 1.0:
		var heal := int(_lifesteal_pool)
		_lifesteal_pool -= heal
		health = min(health + heal, max_health)
		_show_lifesteal_effect()

func _show_lifesteal_effect() -> void:
	var sprite := Sprite2D.new()
	sprite.texture = LIFESTEAL_FX
	sprite.scale = Vector2(0.06, 0.06)
	sprite.z_index = 2
	sprite.global_position = global_position + Vector2(0, -20)
	get_tree().current_scene.add_child(sprite)
	var tween := sprite.create_tween()
	tween.set_parallel(true)
	tween.tween_property(sprite, "position:y", sprite.position.y - 40.0, 0.5)
	tween.tween_property(sprite, "modulate:a", 0.0, 0.5)
	tween.chain().tween_callback(sprite.queue_free)

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
			naginata_damage += 1
			axe_damage += 1
			disc_damage += 1
		"special_a":
			if "projectile" in weapon_keys or "yumi" in weapon_keys:
				pierce_chance += 0.25
			else:
				for weapon in get_tree().get_nodes_in_group("weapons"):
					if weapon.has_method("apply_range_bonus"):
						weapon.apply_range_bonus(1.25)
		"special_b":
			if "projectile" in weapon_keys or "yumi" in weapon_keys:
				multi_chance += 0.20
			else:
				double_attack_chance += 0.20
