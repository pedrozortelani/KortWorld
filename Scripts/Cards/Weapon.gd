extends "res://Scripts/Cards/Equipment.gd"

export(WEAPONTYPE) var weaponType
export(int) var minDmg
export(int) var maxDmg
export(float) var critMultiplier

var combatHandler

func attack(playerStats, target):
	randomize()
	var dmg = (randi() % (maxDmg - minDmg)) + minDmg + playerStats.attack / 4
	var isCritical = (randi()%100 + 1) <= playerStats.critChance
	
	if isCritical:
		dmg *= critMultiplier
	
	var dodged = (randi()%100 + 1) <= target.dodge
	if !dodged:
		if isCritical:
			combatHandler.updateInformationBoard("Critical hit!")
		target.takeDamage(Action.ATYPE.Physical, dmg)
	else:
		combatHandler.updateInformationBoard(target.name + " dodged the attack.")
