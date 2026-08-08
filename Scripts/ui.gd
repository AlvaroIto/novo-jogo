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
	"damage": "+1 Dano do Projétil",
	"pierce": "+25% Chance de Perfurar",
	"multi": "+20% Chance de Tiro Duplo",
}

var current_upgrades: Array = []
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
	var keys := UPGRADES.keys()
	keys.shuffle()
	current_upgrades = keys.slice(0, 3)
	for i in 3:
		upgrade_buttons[i].text = UPGRADES[current_upgrades[i]]
	level_up_screen.visible = true
	get_tree().paused = true

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
	get_tree().paused = false
	get_tree().reload_current_scene()

func _pick_upgrade(index: int) -> void:
	player.apply_upgrade(current_upgrades[index])
	_close_level_up()

func _on_health_button_pressed() -> void:
	_pick_upgrade(0)

func _on_speed_button_pressed() -> void:
	_pick_upgrade(1)

func _on_attack_button_pressed() -> void:
	_pick_upgrade(2)
