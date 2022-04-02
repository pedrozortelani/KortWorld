extends "res://Scripts/Cards/Card.gd"

enum SLOT{helmet, armor, boots, mainhand, offhand, twohanded}
enum WEAPONTYPE{Sword, Bow, Dagger, Mace, Orb, Wand}

export(SLOT) var slot
export(WEAPONTYPE) var weaponTypeBonus
export(Array, String) var weaponTypeBonusStat
export(Array, int) var weaponTypeBonusValue
export(Array, String) var statsList
export(Array, int) var amountList

func equip(player):
	if slot == SLOT.mainhand or slot == SLOT.offhand:
		if player.get("mainhand"):
			if player.get("mainhand").slot == SLOT.twohanded:
				player.set("mainhand", null)
				player.set("offhand", null)
	
	if slot != SLOT.twohanded:
		player.set(SLOT.keys()[slot], self)
	else:
		player.set("mainhand", self)
		player.set("offhand", self)
	
	player.get_parent().get_node("Attributes").updateStats()

func unequip(player):
	player.set(SLOT.keys()[slot], null)
	player.get_parent().get_node("Attributes").updateStats()

func applyBonus(playerStats):
	var counter = 0
	for stat in statsList:
		playerStats.set(stat, playerStats.get(stat) + amountList[counter])
		counter += 1
	
	var equipments = playerStats.get_parent().get_node("Equipments")
	if slot == SLOT.offhand and equipments.get("mainhand") != null:
		if equipments.get("mainhand").weaponType == weaponTypeBonus:
			counter = 0
			for stat in weaponTypeBonusStat:
				playerStats.set(stat, playerStats.get(stat) + weaponTypeBonusValue[counter])
				counter += 1
