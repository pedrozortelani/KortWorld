extends Node

export(int) var level = 1
export(int) var experience = 0
var statPoints = 0

#Primary Stats
export(int) var strength = 5
export(int) var inteligence = 5
export(int) var stamina = 5
export(int) var dexterity = 5

#Secundary Stats
export(int) var hp = 100;
export(int) var currentHp = 100;
export(int) var mana = 50;
export(int) var currentMana = 50;
export(int) var attack = 0;
export(int) var magicattack = 0;
export(int) var defense = 0;
export(int) var magicdefense = 0;
export(int) var critChance = 0;
export(int) var dodge = 0

#signals
signal stat_added

#Active Buffs and DeBuffs
var statsModifiers = []
var statsModifiersAmount = []
var statsModifiersDuration = []

onready var combatHandler = get_tree().root.get_node("Game/Combat")

func _ready():
	updateStats()

func updateStats():
	hp = 60 + stamina * 8
	if currentHp > hp:
		currentHp = hp
	mana = 15 + inteligence * 4
	if currentMana > mana:
		currentMana = mana
	attack = strength * 3 + dexterity
	magicattack = inteligence * 4
	defense = stamina * 2
	magicdefense = inteligence + stamina
	critChance = dexterity / 2
	dodge = dexterity / 3

	get_parent().get_node("Equipments").applySetBonus()

func addStatModifier(statModifier):
	statsModifiers.append(statModifier.targetStat)
	statsModifiersAmount.append(statModifier.statBonus)
	statsModifiersDuration.append(statModifier.durationAmount)
	
	set(statModifier.targetStat, get(statModifier.targetStat) + statModifier.statBonus)
	emit_signal("stat_added")
	
func runStatsModifier():
	var removed = 0
	for index in statsModifiersDuration.size():
		index -= removed
		statsModifiersDuration[index] -= 1
		if statsModifiersDuration[index] == 0:
			if statsModifiersAmount[index] < 0:
				combatHandler.updateInformationBoard("Mike's " + statsModifiers[index] + " is increased by " + str(statsModifiersAmount[index] * -1) +".")
			else:
				combatHandler.updateInformationBoard("Mike's " + statsModifiers[index] + " is decreased by " + str(statsModifiersAmount[index]) +".")
			set(statsModifiers[index], get(statsModifiers[index]) - statsModifiersAmount[index])
			statsModifiers.remove(index)
			statsModifiersAmount.remove(index)
			statsModifiersDuration.remove(index)
			removed += 1

func resetStatsModifier():	
	for stats in statsModifiers:
		set(stats, get(stats) - statsModifiersAmount[0])
		statsModifiers.remove(0)
		statsModifiersAmount.remove(0)
		statsModifiersDuration.remove(0)

func takeDamage(dmgType, dmg):
	var causedDmg
	if dmgType == Action.ATYPE.Physical:
		causedDmg = max(0, dmg - defense/3)
		currentHp = currentHp - causedDmg
	elif dmgType == Action.ATYPE.Magical:
		causedDmg = max(0, dmg - magicdefense/2)
		currentHp = currentHp - causedDmg
		
	return causedDmg

func increaseExperience(amount):
	experience += amount
	if experience >= level * level * 10:
		experience -= level * level * 10
		level += 1
		statPoints += 5
