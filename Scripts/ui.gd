extends CanvasLayer

@onready var health_label: Label = $HealthLabel
@onready var kills_label: Label = $KillsLabel
@onready var time_label: Label = $TimeLabel
@onready var player: Node2D = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
	var game := get_tree().current_scene
	health_label.text = "Vida: %d" % player.health
	kills_label.text = "Abates: %d" % game.kills
	var seconds := int(game.elapsed_time)
	time_label.text = "Tempo: %02d:%02d" % [seconds / 60, seconds % 60]
