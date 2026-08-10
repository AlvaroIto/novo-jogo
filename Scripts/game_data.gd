extends Node

# Dados persistentes entre runs (autoload "GameData")

var total_coins := 0
var upgrade_health := 0
var upgrade_damage := 0
var upgrade_speed := 0
var selected_class := "samurai"

const CLASSES := {
	"samurai": {
		"name": "Samurai",
		"weapon": "slash",
		"passive": "attack_speed",
		"description": "+10% velocidade de ataque",
	},
	"viking": {
		"name": "Viking",
		"weapon": "aura",
		"passive": "berserker",
		"description": "Berserker: menos vida, mais dano",
	},
	"espartano": {
		"name": "Espartano",
		"weapon": "projectile",
		"passive": "projectile_damage",
		"description": "+1 dano em projéteis",
	},
}

const BASE_COSTS := {
	"health": 20,
	"damage": 30,
	"speed": 25,
}

func add_coins(amount: int) -> void:
	total_coins += amount

func get_cost(key: String) -> int:
	var owned: int = get("upgrade_" + key)
	return BASE_COSTS[key] + owned * 10

func can_buy(key: String) -> bool:
	return total_coins >= get_cost(key)

func buy(key: String) -> bool:
	if not can_buy(key):
		return false
	total_coins -= get_cost(key)
	set("upgrade_" + key, get("upgrade_" + key) + 1)
	return true
