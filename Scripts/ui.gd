extends CanvasLayer

@onready var health_label: Label = $HealthLabel
@onready var kills_label: Label = $KillsLabel
@onready var time_label: Label = $TimeLabel
@onready var player: Node2D = get_tree().get_first_node_in_group("player")
@onready var game_over_screen: ColorRect = $GameOverScreen
@onready var stats_label: Label = $GameOverScreen/VBoxContainer/StatsLabel

func _process(_delta: float) -> void:
	var game := get_tree().current_scene
	health_label.text = "Vida: %d" % player.health
	kills_label.text = "Abates: %d" % game.kills
	var seconds := int(game.elapsed_time)
	time_label.text = "Tempo: %02d:%02d" % [seconds / 60, seconds % 60]

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
