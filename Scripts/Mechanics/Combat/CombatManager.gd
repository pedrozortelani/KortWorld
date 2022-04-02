extends Node2D

class_name CombatManager

onready var UIController = get_tree().root.get_node("Game/UserInterface/UI")
onready var UI = get_node("CombatInterface/UI")
onready var rewardScreen = get_node("CombatInterface/Reward")

onready var playerHealthBar = get_node("CombatInterface/UI/PlayerBars/HealthBar")
onready var playerHealthValue = get_node("CombatInterface/UI/PlayerBars/HealthBar/HealthValue")
onready var playerManaBar = get_node("CombatInterface/UI/PlayerBars/ManaBar")
onready var playerManaValue = get_node("CombatInterface/UI/PlayerBars/ManaBar/ManaValue")
onready var playerExpBar = get_node("CombatInterface/UI/PlayerBars/ExpBar")
onready var monster1 = get_node("CombatInterface/UI/Monster1")
onready var monster2 = get_node("CombatInterface/UI/Monster2")
onready var monster3 = get_node("CombatInterface/UI/Monster3")
onready var monster4 = get_node("CombatInterface/UI/Monster4")
const enemy = preload("res://Scripts/Enemies/Enemy.gd")

onready var itensmenu = get_node("CombatInterface/UI/ItensMenu")
onready var itemselector = get_node("CombatInterface/UI/ItensMenu/Item1/Selector")
onready var item1 = get_node("CombatInterface/UI/ItensMenu/Item1")
onready var item2 = get_node("CombatInterface/UI/ItensMenu/Item2")
onready var item3 = get_node("CombatInterface/UI/ItensMenu/Item3")
onready var item4 = get_node("CombatInterface/UI/ItensMenu/Item4")
onready var actionmenu = get_node("CombatInterface/UI/ActionMenu")
onready var actionselector = get_node("CombatInterface/UI/ActionMenu/Option1/Selector")
onready var spellmenu = get_node("CombatInterface/UI/SpellMenu")
onready var spellselector = get_node("CombatInterface/UI/SpellMenu/Option1/Selector")
onready var target1 = get_node("CombatInterface/UI/Monster1/Target")
onready var target2 = get_node("CombatInterface/UI/Monster2/Target")
onready var target3 = get_node("CombatInterface/UI/Monster3/Target")
onready var target4 = get_node("CombatInterface/UI/Monster4/Target")
onready var infoBoard = get_node("CombatInterface/UI/InfoBoard")

var playerStats
var playerEquipments
var playerInventory

var reward = [0]
var turnHandler = []
var turnIndex = 0
var combatConsumables = []
var combatConsumablesAmount = []

var menuindex = 1
var spellindex = 1
var itemindex = 0
var monsterindex = 1
var attacktype = ""
var menutype = "Action"
var hasSpells = false
var spell
var active = false
var infoLines = 0

func _process(delta):
	if active:
		if menutype == "Action":
			if Input.is_action_just_pressed("ui_up") and menuindex > 2:
				menuindex -= 2
				actionselector.get_parent().remove_child(actionselector)
				get_node("CombatInterface/UI/ActionMenu/Option" + str(menuindex)).add_child(actionselector)
			elif Input.is_action_just_pressed("ui_left") and menuindex % 2 == 0:
				menuindex -= 1
				actionselector.get_parent().remove_child(actionselector)
				get_node("CombatInterface/UI/ActionMenu/Option" + str(menuindex)).add_child(actionselector)
			elif Input.is_action_just_pressed("ui_right") and menuindex % 2 == 1:
				menuindex += 1
				actionselector.get_parent().remove_child(actionselector)
				get_node("CombatInterface/UI/ActionMenu/Option" + str(menuindex)).add_child(actionselector)
			elif Input.is_action_just_pressed("ui_down") and menuindex < 3:
				menuindex += 2
				actionselector.get_parent().remove_child(actionselector)
				get_node("CombatInterface/UI/ActionMenu/Option" + str(menuindex)).add_child(actionselector)
			
			
			if Input.is_action_just_pressed("ui_accept"):
				if menuindex == 1:
					menutype = "Target"
					if monster1.visible:
						target1.visible = true
						monsterindex = 1
					elif monster2.visible:
						target2.visible = true
						monsterindex = 2
					elif monster3.visible:
						target3.visible = true
						monsterindex = 3
					elif monster4.visible:
						target4.visible = true
						monsterindex = 4
					attacktype = "Physical"
				elif menuindex == 2 and hasSpells:
					menutype = "Spells"
					spellindex = 1
					spellselector.get_parent().remove_child(spellselector)
					get_node("CombatInterface/UI/SpellMenu/Option1").add_child(spellselector)
					actionmenu.visible = false
					spellmenu.visible = true
				elif menuindex == 3 and combatConsumables.size() != 0:
					menutype = "Itens"
					updateItemList(0)
					itemselector.get_parent().remove_child(itemselector)
					get_node("CombatInterface/UI/ItensMenu/Item1").add_child(itemselector)
					itemindex = 0
					itensmenu.visible = true
				elif menuindex == 4:
					randomize()
					if randi()%100+1 <= 75:
						for obj in turnHandler:
							if obj is preload("res://Scripts/Enemies/Enemy.gd"):
								obj.queue_free()
						endCombat()
					else:
						updateInformationBoard("Failed to run from combat!")
						passTurn()
		elif menutype == "Itens":
			if Input.is_action_just_pressed("ui_up") and itemindex > 0:
				itemindex -= 1
				if itemselector.get_parent().name != "Item1":
					var parent = itemselector.get_parent()
					var parentindex = parent.name.substr(4,1)
					itemselector.get_parent().remove_child(itemselector)
					get_node("CombatInterface/UI/ItensMenu/Item" + str(int(parentindex) - 1)).add_child(itemselector)
				else:
					updateItemList(itemindex)
			elif Input.is_action_just_pressed("ui_down") and itemindex < combatConsumables.size() - 1:
				itemindex += 1
				if itemselector.get_parent().name != "Item4":
					var parent = itemselector.get_parent()
					var parentindex = parent.name.substr(4,1)
					itemselector.get_parent().remove_child(itemselector)
					get_node("CombatInterface/UI/ItensMenu/Item" + str(int(parentindex) + 1)).add_child(itemselector)
				else:
					updateItemList(itemindex - 3)
			
			if Input.is_action_just_pressed("ui_accept"):
				combatConsumables[itemindex].useConsumable(playerStats, Consumable.USAGE.Combat)
				combatConsumablesAmount[itemindex] -= 1
				
				updateInformationBoard("You used the consumable " + combatConsumables[itemindex].name + ".")
				
				if combatConsumablesAmount[itemindex] == 0:
					combatConsumables.remove(itemindex)
					combatConsumablesAmount.remove(itemindex)
			
				itensmenu.visible = false
				atualizeUI()
				passTurn()
			
			if Input.is_action_just_pressed("ui_cancel"):
				menutype = "Action"
				itensmenu.visible = false
		elif menutype == "Spells":
			if Input.is_action_just_pressed("ui_up") and spellindex > 2:
				spellindex -= 2
				spellselector.get_parent().remove_child(spellselector)
				get_node("CombatInterface/UI/SpellMenu/Option" + str(spellindex)).add_child(spellselector)
			elif Input.is_action_just_pressed("ui_left") and spellindex % 2 == 0:
				spellindex -= 1
				spellselector.get_parent().remove_child(spellselector)
				get_node("CombatInterface/UI/SpellMenu/Option" + str(spellindex)).add_child(spellselector)
			elif Input.is_action_just_pressed("ui_right") and spellindex % 2 == 1:
				spellindex += 1
				spellselector.get_parent().remove_child(spellselector)
				get_node("CombatInterface/UI/SpellMenu/Option" + str(spellindex)).add_child(spellselector)
			elif Input.is_action_just_pressed("ui_down") and spellindex < 3:
				spellindex += 2
				spellselector.get_parent().remove_child(spellselector)
				get_node("CombatInterface/UI/SpellMenu/Option" + str(spellindex)).add_child(spellselector)
			
			if Input.is_action_just_pressed("ui_accept"):
				if spellmenu.get_node("Option" + str(spellindex)).text != "---":
					spell = playerEquipments.get("spell" + str(spellindex))
					if playerStats.currentMana >= spell.manaCost:
						attacktype = "Spell"
						menutype = "Target"
						if spell.targetType == Spell.TARGET.Single:
							if monster1.visible:
								target1.visible = true
								monsterindex = 1
							elif monster2.visible:
								target2.visible = true
								monsterindex = 2
							elif monster3.visible:
								target3.visible = true
								monsterindex = 3
							elif monster4.visible:
								target4.visible = true
								monsterindex = 4
						elif spell.targetType == Spell.TARGET.All:
							if monster1.visible:
								target1.visible = true
								monsterindex = 1
							if monster2.visible:
								target2.visible = true
								monsterindex = 2
							if monster3.visible:
								target3.visible = true
								monsterindex = 3
							if monster4.visible:
								target4.visible = true
								monsterindex = 4
						
			if Input.is_action_just_pressed("ui_cancel"):
				menutype = "Action"
				actionmenu.visible = true
				spellmenu.visible = false
		elif menutype == "Target":
			if attacktype == "Physical":
				if Input.is_action_just_pressed("ui_cancel"):
					menutype = "Action"
					target1.visible = false
					target2.visible = false
					target3.visible = false
					target4.visible = false
				
				if Input.is_action_just_pressed("ui_down") and monster1.visible:
					monsterindex = 1
					target1.visible = true
					target2.visible = false
					target3.visible = false
					target4.visible = false
				elif Input.is_action_just_pressed("ui_left") and monster2.visible:
					monsterindex = 2
					target2.visible = true
					target1.visible = false
					target3.visible = false
					target4.visible = false
				elif Input.is_action_just_pressed("ui_right") and monster3.visible:
					monsterindex = 3
					target3.visible = true
					target1.visible = false
					target2.visible = false
					target4.visible = false
				elif Input.is_action_just_pressed("ui_up") and monster4.visible:
					monsterindex = 4
					target4.visible = true
					target1.visible = false
					target2.visible = false
					target3.visible = false
				
				if Input.is_action_just_pressed("ui_accept"):
					var target
					for child in get_node("CombatInterface/UI/Monster" + str(monsterindex)).get_children():
						if child is enemy:
							target = child
					if playerEquipments.mainhand != null:
						playerEquipments.mainhand.attack(playerStats, target)
					else:
						var dodged = (randi()%100 + 1) <= target.dodge
						if !dodged:
							target.takeDamage(Action.ATYPE.Physical, playerStats.attack / 4)
						else:
							updateInformationBoard(target.name + " dodged the attack.")
					passTurn()
			elif attacktype == "Spell":
				if Input.is_action_just_pressed("ui_cancel"):
					menutype = "Spells"
					target1.visible = false
					target2.visible = false
					target3.visible = false
					target4.visible = false
				
				if Input.is_action_just_pressed("ui_accept"):
					var target = []
					if spell.targetType == Spell.TARGET.Self:
						target.append(playerStats)
					elif spell.targetType == Spell.TARGET.All:
						for i in 4:
							for child in get("monster" + str(i + 1)).get_children():
								if child is enemy:
									target.append(child)
					elif spell.targetType == Spell.TARGET.Single:
						for child in get_node("CombatInterface/UI/Monster" + str(monsterindex)).get_children():
							if child is enemy:
								target.append(child)
					if spell.effectType == Spell.EFFECT.Damage:
							spell.castDmgSpell(playerStats, target)
					elif spell.effectType == Spell.EFFECT.Status:
							spell.castStatusSpell(playerStats, target)
					passTurn()
				if spell.targetType == Spell.TARGET.Single:
					if Input.is_action_just_pressed("ui_down") and monster1.visible:
						monsterindex = 1
						target1.visible = true
						target2.visible = false
						target3.visible = false
						target4.visible = false
					elif Input.is_action_just_pressed("ui_left") and monster2.visible:
						monsterindex = 2
						target2.visible = true
						target1.visible = false
						target3.visible = false
						target4.visible = false
					elif Input.is_action_just_pressed("ui_right") and monster3.visible:
						monsterindex = 3
						target3.visible = true
						target1.visible = false
						target2.visible = false
						target4.visible = false
					elif Input.is_action_just_pressed("ui_up") and monster4.visible:
						monsterindex = 4
						target4.visible = true
						target1.visible = false
						target2.visible = false
						target3.visible = false

func activateCombat(monsterList, player):
	turnIndex = 0
	reward = [0]
	turnHandler = []
	infoBoard.text = ""
	infoLines = 0
	infoBoard.lines_skipped = 0
	turnHandler.append(player)
	playerStats = player.get_node("Attributes")
	playerEquipments = player.get_node("Equipments")
	if playerEquipments.mainhand != null:
		playerEquipments.mainhand.combatHandler = self
	playerInventory = player.get_node("Inventory")
	
	if playerEquipments.spell1 != null:
		playerEquipments.spell1.combatHandler = self
		get_node("CombatInterface/UI/SpellMenu/Option1").text = playerEquipments.spell1.name
		hasSpells = true
	else:
		get_node("CombatInterface/UI/SpellMenu/Option1").text = "---"
	if playerEquipments.spell2 != null:
		playerEquipments.spell2.combatHandler = self
		get_node("CombatInterface/UI/SpellMenu/Option2").text = playerEquipments.spell2.name
		hasSpells = true
	else:
		get_node("CombatInterface/UI/SpellMenu/Option2").text = "---"
	if playerEquipments.spell3 != null:
		playerEquipments.spell3.combatHandler = self
		get_node("CombatInterface/UI/SpellMenu/Option3").text = playerEquipments.spell3.name
		hasSpells = true
	else:
		get_node("CombatInterface/UI/SpellMenu/Option3").text = "---"
	if playerEquipments.spell4 != null:
		playerEquipments.spell4.combatHandler = self
		get_node("CombatInterface/UI/SpellMenu/Option4").text = playerEquipments.spell4.name
		hasSpells = true
	else:
		get_node("CombatInterface/UI/SpellMenu/Option4").text = "---"
	
	var counter = 0
	
	combatConsumables = []
	combatConsumablesAmount = []
	
	for consumable in playerInventory.consumableCards:
		if consumable.usage != Consumable.USAGE.NonCombat:
			combatConsumables.append(consumable)
			combatConsumablesAmount.append(playerInventory.consumableAmount[counter])
			counter += 1
		
	counter = 1
	for monster in monsterList:
		var newMonster = monster.instance()
		get_node("CombatInterface/UI/Monster" + str(counter)).add_child(newMonster)
		get_node("CombatInterface/UI/Monster" + str(counter)).visible = true
		var healthbar = get_node("CombatInterface/UI/Monster" + str(counter)).get_node("HealthBar")
		healthbar.max_value = newMonster.hp
		healthbar.value = newMonster.hp
		turnHandler.append(newMonster)
		counter += 1
	
	atualizeUI()
	UI.visible = true
	turnHandler[turnIndex].takeTurn()

func atualizeUI():
	playerHealthBar.max_value = playerStats.hp
	playerHealthBar.value = playerStats.currentHp
	playerHealthValue.text = str(playerStats.currentHp) + "/" + str(playerStats.hp)
	playerManaBar.max_value = playerStats.mana
	playerManaBar.value = playerStats.currentMana
	playerManaValue.text = str(playerStats.currentMana) + "/" + str(playerStats.mana)
	playerExpBar.max_value = playerStats.level * playerStats.level * 10
	playerExpBar.value = playerStats.experience

func endCombat():
	active = false
	actionmenu.visible = true
	actionselector.get_parent().remove_child(actionselector)
	get_node("CombatInterface/UI/ActionMenu/Option1").add_child(actionselector)
	spellmenu.visible = false
	spellselector.get_parent().remove_child(spellselector)
	get_node("CombatInterface/UI/SpellMenu/Option1").add_child(spellselector)
	get_node("CombatInterface/UI/Monster1").visible = false
	get_node("CombatInterface/UI/Monster2").visible = false
	get_node("CombatInterface/UI/Monster3").visible = false
	get_node("CombatInterface/UI/Monster4").visible = false
	
	rewardScreen.applyReward(playerStats, playerInventory, reward)
	
	UIController.updateUI(playerStats)
	playerStats.resetStatsModifier()
	UI.visible = false

func passTurn():
	active = false
	actionselector.visible = false
	actionmenu.visible = true
	actionselector.get_parent().remove_child(actionselector)
	get_node("CombatInterface/UI/ActionMenu/Option1").add_child(actionselector)
	spellmenu.visible = false
	target1.visible = false
	target2.visible = false
	target3.visible = false
	target4.visible = false
	atualizeUI()
	
	var t = Timer.new()
	t.set_wait_time(0.75)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
		
	if turnHandler.size() == 1:
		endCombat()
	else:
		turnIndex += 1
		
		if turnIndex >= turnHandler.size():
			turnIndex = 0
			playerStats.runStatsModifier()
		
		turnHandler[turnIndex].takeTurn()

func updateItemList(startIndex):
	item1.texture = combatConsumables[startIndex].texture
	item1.get_node("Name").text = combatConsumables[startIndex].name
	item1.get_node("Quantity").text = str(combatConsumablesAmount[startIndex])
	
	if startIndex + 1 < combatConsumables.size():
		item2.texture = combatConsumables[startIndex + 1].texture
		item2.get_node("Name").text = combatConsumables[startIndex + 1].name
		item2.get_node("Quantity").text = str(combatConsumablesAmount[startIndex + 1])
	else:
		item2.texture = null
		item2.get_node("Name").text = ""
		item2.get_node("Quantity").text = ""
	if startIndex + 2 < combatConsumables.size():
		item3.texture = combatConsumables[startIndex + 2].texture
		item3.get_node("Name").text = combatConsumables[startIndex + 2].name
		item3.get_node("Quantity").text = str(combatConsumablesAmount[startIndex + 2])
	else:
		item3.texture = null
		item3.get_node("Name").text = ""
		item3.get_node("Quantity").text = ""
	if startIndex + 3 < combatConsumables.size():
		item4.texture = combatConsumables[startIndex + 3].texture
		item4.get_node("Name").text = combatConsumables[startIndex + 3].name
		item4.get_node("Quantity").text = str(combatConsumablesAmount[startIndex + 3])
	else:
		item4.texture = null
		item4.get_node("Name").text = ""
		item4.get_node("Quantity").text = ""

func updateInformationBoard(newLine):
	infoBoard.text += newLine + "\n"
	infoLines += 1
	if infoLines > 6:
		infoBoard.lines_skipped += 1
