extends CanvasLayer

@onready var health_label: Label = $HealthLabel
@onready var kills_label: Label = $KillsLabel
@onready var time_label: Label = $TimeLabel
@onready var player: Node2D = get_tree().get_first_node_in_group("player")
@onready var game_over_screen: ColorRect = $GameOverScreen
@onready var stats_label: Label = $GameOverScreen/VBoxContainer/StatsLabel
@onready var level_up_screen: ColorRect = $LevelUpScreen
@onready var level_label: Label = $LevelLabel
@onready var upgrade_buttons: Array = [
	$LevelUpScreen/VBoxContainer/HealthButton,
	$LevelUpScreen/VBoxContainer/SpeedButton,
	$LevelUpScreen/VBoxContainer/AttackButton,
]

const UPGRADES := {
	"health": "+20 Vida Máxima",
	"speed": "+10% Velocidade",
	"attack_speed": "+15% Velocidade de Ataque",
	"damage": "+1 Dano (todas as armas)",
	"special_a": "",
	"special_b": "",
}

var current_upgrades: Array = []

@onready var victory_screen: ColorRect = $VictoryScreen
@onready var victory_stats_label: Label = $VictoryScreen/VBoxContainer/StatsLabel
@onready var distance_label: Label = $DistanceLabel
@onready var coins_label: Label = $CoinsLabel

func _process(_delta: float) -> void:
	var game := get_tree().current_scene
	health_label.text = "Vida: %d" % player.health
	kills_label.text = "Abates: %d" % game.kills
	level_label.text = "Nível: %d" % player.level
	distance_label.text = "Distância: %d m" % int(game.max_distance)
	coins_label.text = "Moedas: %d" % game.coins
	var seconds := int(game.elapsed_time)
	time_label.text = "Tempo: %02d:%02d" % [seconds / 60, seconds % 60]

func show_level_up() -> void:
	var pool := UPGRADES.keys()
	var extras: Array = GameData.CLASSES[GameData.selected_class].get("extra_weapons", [])
	if player.weapon_keys.size() < player.MAX_WEAPONS:
		for w in extras:
			if w not in player.weapon_keys:
				pool.append("weapon:" + w)
	pool.shuffle()
	current_upgrades = pool.slice(0, 3)
	for i in 3:
		upgrade_buttons[i].text = _get_upgrade_text(current_upgrades[i])
	level_up_screen.visible = true
	get_tree().paused = true

func _get_upgrade_text(key: String) -> String:
	if key.begins_with("weapon:"):
		var w := key.trim_prefix("weapon:")
		return "Nova arma: " + GameData.WEAPON_NAMES.get(w, w)
	match key:
		"special_a":
			if "projectile" in player.weapon_keys or "yumi" in player.weapon_keys:
				return "+25% Chance de Perfurar"
			return "+25% Alcance da Arma"
		"special_b":
			if "projectile" in player.weapon_keys or "yumi" in player.weapon_keys:
				return "+20% Chance de Tiro Duplo"
			return "+20% Chance de Ataque Duplo"
	return UPGRADES[key]

func _close_level_up() -> void:
	level_up_screen.visible = false
	get_tree().paused = false

func show_game_over() -> void:
	var game := get_tree().current_scene
	var seconds := int(game.elapsed_time)
	stats_label.text = "GAME OVER\n\nTempo: %02d:%02d\nAbates: %d" % [seconds / 60, seconds % 60, game.kills]
	health_label.visible = false
	kills_label.visible = false
	time_label.visible = false
	game_over_screen.visible = true
	get_tree().paused = true

func _on_restart_button_pressed() -> void:
	_go_to_camp()

func show_victory() -> void:
	var game := get_tree().current_scene
	var seconds := int(game.elapsed_time)
	victory_stats_label.text = "Território conquistado!\n\nDistância: %d m\nTempo: %02d:%02d\nAbates: %d\nMoedas: %d" % [int(game.max_distance), seconds / 60, seconds % 60, game.kills, game.coins]
	health_label.visible = false
	kills_label.visible = false
	time_label.visible = false
	level_label.visible = false
	distance_label.visible = false
	coins_label.visible = false
	victory_screen.visible = true
	get_tree().paused = true

func _on_continue_button_pressed() -> void:
	_go_to_camp()

func _go_to_camp() -> void:
	var game := get_tree().current_scene
	GameData.add_coins(game.coins)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/camp.tscn")

func _pick_upgrade(index: int) -> void:
	var key: String = current_upgrades[index]
	if key.begins_with("weapon:"):
		player.add_weapon(key.trim_prefix("weapon:"))
	else:
		player.apply_upgrade(key)
	_close_level_up()

func _on_health_button_pressed() -> void:
	_pick_upgrade(0)

func _on_speed_button_pressed() -> void:
	_pick_upgrade(1)

func _on_attack_button_pressed() -> void:
	_pick_upgrade(2)
