extends "res://Scripts/Cards/Card.gd"

class_name Consumable

enum USAGE{All, Combat, NonCombat}
enum DURATION{Instant, NonInstant}

export(USAGE) var usage
export(DURATION) var duration
export(String) var targetStat
export(int) var statBonus
export(int) var durationAmount

func useConsumable(playerStats, useSituation):
	
	if useSituation == usage or usage == USAGE.All:
		if duration == DURATION.Instant:
			playerStats.set(targetStat, playerStats.get(targetStat) + statBonus)
			if targetStat == "currentHp":
				if playerStats.currentHp > playerStats.hp:
					playerStats.currentHp = playerStats.hp
			elif targetStat == "currentMana":
				if playerStats.currentMana > playerStats.mana:
					playerStats.currentMana = playerStats.mana	
		elif duration == DURATION.NonInstant:
			playerStats.addStatModifier(self)
			
		reduceAmount(playerStats)

func reduceAmount(playerStats):
	var inventory = playerStats.get_parent().get_node("Inventory")
	inventory.consumableAmount[inventory.consumableCards.find(self)] -= 1
	if inventory.consumableAmount[inventory.consumableCards.find(self)] == 0:
		inventory.consumableAmount.remove(inventory.consumableCards.find(self))
		inventory.consumableCards.erase(self)
