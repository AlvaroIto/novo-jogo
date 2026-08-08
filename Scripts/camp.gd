extends Control

@onready var coins_label: Label = $VBoxContainer/CoinsLabel
@onready var health_button: Button = $VBoxContainer/HealthButton
@onready var damage_button: Button = $VBoxContainer/DamageButton
@onready var speed_button: Button = $VBoxContainer/SpeedButton

func _ready() -> void:
	_refresh()

func _refresh() -> void:
	coins_label.text = "Moedas: %d" % GameData.total_coins
	health_button.text = "+10 Vida Máxima (Nv. %d) — %d moedas" % [GameData.upgrade_health, GameData.get_cost("health")]
	damage_button.text = "+1 Dano (Nv. %d) — %d moedas" % [GameData.upgrade_damage, GameData.get_cost("damage")]
	speed_button.text = "+5%% Velocidade (Nv. %d) — %d moedas" % [GameData.upgrade_speed, GameData.get_cost("speed")]
	health_button.disabled = not GameData.can_buy("health")
	damage_button.disabled = not GameData.can_buy("damage")
	speed_button.disabled = not GameData.can_buy("speed")

func _on_health_button_pressed() -> void:
	GameData.buy("health")
	_refresh()

func _on_damage_button_pressed() -> void:
	GameData.buy("damage")
	_refresh()

func _on_speed_button_pressed() -> void:
	GameData.buy("speed")
	_refresh()

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/game.tscn")
