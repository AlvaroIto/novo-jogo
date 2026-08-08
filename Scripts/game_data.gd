extends Node

# Dados persistentes entre runs (autoload "GameData")

var total_coins := 0
var upgrade_health := 0
var upgrade_damage := 0
var upgrade_speed := 0

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
