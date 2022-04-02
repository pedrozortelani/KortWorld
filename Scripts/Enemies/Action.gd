extends Node

class_name Action

enum EFFECT{
	Damage,
	Debuff,
	Nothing
}

enum ATYPE{
	Physical,
	Magical
}

export(String) var description
export(EFFECT) var effectType

export(String) var targetStat
export(float) var statBonus
export(int) var durationAmount
export(ATYPE) var dmgType 
export(int) var minDmg
export(int) var maxDmg
export(float) var critMultiplier = 1.5

func act(combatHandler, enemy):
	if effectType == EFFECT.Damage:
		description = enemy.name + " " + description
		var player = combatHandler.turnHandler[0].get_node("Attributes")
		var dmg 
		if dmgType == ATYPE.Physical:
			dmg = (randi() % (maxDmg - minDmg)) + minDmg + enemy.attack / 4
		elif dmgType == ATYPE.Magical:
			dmg = (randi() % (maxDmg - minDmg)) + minDmg + enemy.magicattack * 4 / 10
		var isCritical = (randi()%100 + 1) <= enemy.critchance
		if isCritical:
			dmg *= critMultiplier
		
		var dmgCaused
		var dodged = (randi()%100 + 1) <= player.dodge
		if !dodged:
			if isCritical:
				combatHandler.updateInformationBoard("Critical hit!")
			dmgCaused = combatHandler.turnHandler[0].get_node("Attributes").takeDamage(dmgType, dmg)
		else:
			combatHandler.updateInformationBoard(player.name + " dodged the attack.")

		description += " Caused: " + str(dmgCaused) + " damage."
	elif effectType == EFFECT.Debuff:
		description = "Mike " + description
		statBonus = int(combatHandler.turnHandler[0].get_node("Attributes").get(targetStat) * statBonus) * -1
		combatHandler.turnHandler[0].get_node("Attributes").addStatModifier(self)
	else:
		description = enemy.name + " " + description
	
	combatHandler.updateInformationBoard(description)
	yield(combatHandler.turnHandler[0].get_node("Attributes"), "stat_added")
	queue_free()
