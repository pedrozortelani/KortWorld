extends Consumable

export(int) var stepsAmount

func useConsumable(playerStats, useSituation):
	var player = playerStats.get_parent()
	player.steps = stepsAmount
	player.hasTalisman = true
	
	reduceAmount(playerStats)
