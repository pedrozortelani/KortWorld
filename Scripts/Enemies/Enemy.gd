extends AnimatedSprite

export(int) var hp
export(int) var attack
export(int) var magicattack
export(int) var defense
export(int) var magicdefense
export(int) var critchance
export(int) var dodge
export(Array, PackedScene) var actions
export(Array, int) var actionChance

export(int) var experience
export(Array, PackedScene) var dropList
export(Array, int) var dropChance

onready var combatHandler = get_tree().root.get_node("Game/Combat")
onready var playerStats = get_tree().root.get_node("Game/Map/Player/Attributes")

var isAlive = true

func takeTurn():
	if isAlive:
		randomize()
		var actionIndex = randi()%100 + 1;
		var actionSelected
		
		for i in actionChance.size():
			if actionIndex <= actionChance[i]:
				actionSelected = actions[i]
				break
		
		var newAction = actionSelected.instance()
		newAction.act(combatHandler, self)
	
	combatHandler.passTurn()
	
func takeDamage(dmgType, dmg):
	var causedDmg
	if dmgType == Action.ATYPE.Physical:
		causedDmg = int(max(0, dmg - defense/3))
		hp = hp - causedDmg
	elif dmgType == Action.ATYPE.Magical:
		causedDmg = int(max(0, dmg - magicdefense/2))
		hp = hp - causedDmg
	
	combatHandler.updateInformationBoard(name + " took " + str(causedDmg) + " damage from your attack.")
	
	get_parent().get_node("HealthBar").value = hp
	
	if hp <= 0:
		die()

func die():
	isAlive = false
	get_parent().get_parent().get_parent().get_parent().turnHandler.erase(self)
	playerStats.increaseExperience(experience)
	get_tree().root.get_node("Game/Combat")
	combatHandler.reward[0] += experience
	randomize()
	for i in dropList.size():
		var itemDropChance = randi()%100 + 1
		if itemDropChance <= dropChance[i]:
			combatHandler.reward.append(dropList[i])

	play("death")

func _on_Goblin_animation_finished():
	if animation == "death":
		get_parent().visible = false
		get_parent().remove_child(self)
		queue_free()
