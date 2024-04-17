extends Node

var balance = 100
var tile_posiiton
var energy_generated = 0

var solar = {"name": "solar panel", "price": 100, "productionRate": 10, "upgradePrice": 100, "emissionRate": 100}
var coal = {"name": "coal powerplant", "price": 100, "productionRate": 10, "upgradePrice": 100, "emissionRate": 100}
var water = {"name": "waterturbine", "price": 100, "productionRate": 10, "upgradePrice": 100, "emissionRate": 100}
var wind = {"name": "windturbine", "price": 100, "productionRate": 10, "upgradePrice": 100, "emissionRate": 100}
var bio = {"name": "biogas plant", "price": 100, "productionRate": 10, "upgradePrice": 100, "emissionRate": 100}

var level1 = {"wind": 0.1, "sun": 0.8, "energy_required": 1000, "max_emission": 1000}
var level2 = {"wind": 0, "sun": 0, "energy_required": 1000, "max_emission": 1000}
var level3 = {"wind": 0, "sun": 0, "energy_required": 1000, "max_emission": 1000}

func update_balance(value):
	balance+=value
