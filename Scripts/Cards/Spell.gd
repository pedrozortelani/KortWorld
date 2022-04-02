extends "res://Scripts/Cards/Card.gd"

class_name Spell

enum EFFECT{Damage, Status}
enum TARGET{Self, Single, All}

export(EFFECT) var effectType
export(TARGET) var targetType
export(int) var manaCost
export(int) var minDmg
export(int) var maxDmg
export(String) var targetStat
export(float) var statBonus
export(String) var spellDescription

var combatHandler

func equipSpell(equipments, slot):
	equipments.set("spell" + str(slot), self)

func castDmgSpell(playerStats, targetList):
	randomize()
	for target in targetList:
		var dmg = (randi() % (maxDmg - minDmg)) + minDmg + playerStats.magicattack * 4 / 10 
		
		var isCritical = (randi()%100 + 1) <= playerStats.critChance
	
		if isCritical:
			dmg *= 1.5
		var dodged = (randi()%100 + 1) <= target.dodge
		if !dodged:
			if isCritical:
				combatHandler.updateInformationBoard("Critical hit!")
			target.takeDamage(Action.ATYPE.Magical, dmg)
		else:
			combatHandler.updateInformationBoard(target.name + " dodged the spell.")
	
	playerStats.currentMana -= manaCost

func castStatusSpell(playerStats, targetList):
	for target in targetList:
		if target == playerStats:
			playerStats.addStatModifier(self)
		else:
			combatHandler.updateInformationBoard(target.name + " " + spellDescription)
			target.set(targetStat, int(target.get(targetStat) * statBonus))
	
	playerStats.currentMana -= manaCost
