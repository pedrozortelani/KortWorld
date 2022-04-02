extends Control

var active = false
var slotting = false
var index = 0
var inventoryindex = 0
var itemindex = 1
var spellindex

onready var mainmenu = get_parent().get_parent()
onready var uiController = mainmenu.get_parent().get_parent().get_node("UserInterface/UI")

onready var lefttext = get_node("LeftText")
onready var centertext = get_node("CenterText")
onready var righttext = get_node("RightText")
onready var selector = get_node("Slots/Slot1/Selector")

onready var mainhand = get_node("Equiped/MainHand")
onready var offhand = get_node("Equiped/OffHand")
onready var helmet = get_node("Equiped/Helmet")
onready var armor = get_node("Equiped/Armor")
onready var boots = get_node("Equiped/Boots")
onready var spell1 = get_node("Equiped/Spell1")
onready var spell2 = get_node("Equiped/Spell2")
onready var spell3 = get_node("Equiped/Spell3")
onready var spell4 = get_node("Equiped/Spell4")

onready var healthvalue = get_node("HealthValue")
onready var manavalue = get_node("ManaValue")
onready var attackvalue = get_node("AttackValue")
onready var magicattackvalue = get_node("MagicAttackValue")
onready var defensevalue = get_node("DefenseValue")
onready var magicdefensevalue = get_node("MagicDefenseValue")
onready var criticalchancevalue = get_node("CriticalChanceValue")
onready var dodgevalue = get_node("DodgeValue")

onready var descriptionImg = get_node("DescriptionImg")
onready var descriptionName = get_node("ItemName")
onready var descriptionText = get_node("ItemDescription")

func _process(delta):
	if active and !slotting:
		if Input.is_action_just_pressed("ui_cancel") and index == 0:
			visible = false
			active = false
			mainmenu.index = 0;
			lefttext.text = "Equipments"
			centertext.text = "Consumables"
			righttext.text = "Spells"
			mainmenu.statsBtn.grab_focus()
		if Input.is_action_just_pressed("ui_page_down"):
			var auxtext = lefttext.text
			lefttext.text = centertext.text
			centertext.text = righttext.text
			righttext.text = auxtext
			inventoryindex += 1
			if inventoryindex == 3:
				inventoryindex = 0
			itemindex = 1
			selector.get_parent().remove_child(selector)
			get_node("Slots/Slot1").add_child(selector)
			atualizeInventory()
			atualizeDescription()
		if Input.is_action_just_pressed("ui_page_up"):
			var auxtext = righttext.text
			righttext.text = centertext.text
			centertext.text = lefttext.text
			lefttext.text = auxtext
			inventoryindex -= 1
			if inventoryindex == -1:
				inventoryindex = 2
			itemindex = 1
			selector.get_parent().remove_child(selector)
			get_node("Slots/Slot1").add_child(selector)
			atualizeInventory()
			atualizeDescription()
			
		if Input.is_action_just_pressed("ui_up"):
			if itemindex - 5 > 0:
				itemindex -= 5
				var parentname = "Slot" + str(itemindex)
				selector.get_parent().remove_child(selector)
				get_node("Slots/" + parentname).add_child(selector)
				atualizeDescription()
		elif Input.is_action_just_pressed("ui_left"):
			if itemindex % 5 != 1:
				itemindex -= 1
				var parentname = "Slot" + str(itemindex)
				selector.get_parent().remove_child(selector)
				get_node("Slots/" + parentname).add_child(selector)
				atualizeDescription()
		elif Input.is_action_just_pressed("ui_right"):
			if itemindex % 5 != 0 and get_node("Slots/Slot" + str(itemindex + 1)).texture != null:
				itemindex += 1
				var parentname = "Slot" + str(itemindex)
				selector.get_parent().remove_child(selector)
				get_node("Slots/" + parentname).add_child(selector)
				atualizeDescription()
		elif Input.is_action_just_pressed("ui_down"):
			if get_node("Slots/Slot" + str(itemindex + 5)):
				if get_node("Slots/Slot" + str(itemindex + 5)).texture != null:
					itemindex += 5
					var parentname = "Slot" + str(itemindex)
					selector.get_parent().remove_child(selector)
					get_node("Slots/" + parentname).add_child(selector)
					atualizeDescription()
		
		if Input.is_action_just_pressed("ui_accept") and selector.get_parent().texture != null:
			equipItem()
	
	elif active and slotting:
		var inventory = mainmenu.inputHandler.get_node("Inventory")
		var equipments = mainmenu.inputHandler.get_node("Equipments")
		if Input.is_action_just_pressed("ui_cancel"):
			spellindex = 0
			slotting = false
			var parentname = "Slot" + str(itemindex)
			selector.get_parent().remove_child(selector)
			get_node("Slots/" + parentname).add_child(selector)
		if Input.is_action_just_pressed("ui_accept"):
			inventory.spellCards[itemindex - 1].equipSpell(equipments, spellindex)
			spellindex = 0
			slotting = false
			var parentname = "Slot" + str(itemindex)
			selector.get_parent().remove_child(selector)
			get_node("Slots/" + parentname).add_child(selector)
			atualizeEquipments(equipments)
			atualizeStats()
		if Input.is_action_just_pressed("ui_left"):
			if spellindex > 1:
				spellindex -= 1
				var parentname = "Equiped/Spell" + str(spellindex)
				selector.get_parent().remove_child(selector)
				get_node(parentname).add_child(selector)
		if Input.is_action_just_pressed("ui_right"):
			if spellindex < 4:
				spellindex += 1
				var parentname = "Equiped/Spell" + str(spellindex)
				selector.get_parent().remove_child(selector)
				get_node(parentname).add_child(selector)

func atualizeInventory():
	var inventory = mainmenu.inputHandler.get_node("Inventory")
	
	if inventoryindex == 0:
		var count = 0
		for sprite in get_node("Slots").get_children():
			if count < inventory.consumableCards.size():
				sprite.texture = inventory.consumableCards[count].texture
			else:
				sprite.texture = null
			count += 1
	elif inventoryindex == 1:
		var count = 0
		for sprite in get_node("Slots").get_children():
			if count < inventory.spellCards.size():
				sprite.texture = inventory.spellCards[count].texture
			else:
				sprite.texture = null
			count += 1
	elif inventoryindex == 2:
		var count = 0
		for sprite in get_node("Slots").get_children():
			if count < inventory.equipmentCards.size():
				sprite.texture = inventory.equipmentCards[count].texture
			else:
				sprite.texture = null
			count += 1

func atualizeDescription():
	descriptionImg.texture = null
	descriptionName.text = ""
	descriptionText.text = ""
	var inventory = mainmenu.inputHandler.get_node("Inventory")
	
	descriptionImg.texture = get_node("Slots/Slot" + str(itemindex)).texture
	
	if inventoryindex == 0 and inventory.consumableCards.size() > 0:
		descriptionName.text = inventory.consumableCards[itemindex - 1].name
		descriptionText.text = inventory.consumableCards[itemindex - 1].description
	elif inventoryindex == 1 and inventory.spellCards.size() > 0:
		descriptionName.text = inventory.spellCards[itemindex - 1].name
		descriptionText.text = inventory.spellCards[itemindex - 1].description
	elif inventoryindex == 2 and inventory.equipmentCards.size() > 0:
		descriptionName.text = inventory.equipmentCards[itemindex - 1].name
		descriptionText.text = inventory.equipmentCards[itemindex - 1].description

func equipItem():
	var inventory = mainmenu.inputHandler.get_node("Inventory")
	var equipments = mainmenu.inputHandler.get_node("Equipments")
	
	if inventoryindex == 0:
		inventory.consumableCards[itemindex - 1].useConsumable(mainmenu.inputHandler.get_node("Attributes"), Consumable.USAGE.NonCombat)
		uiController.updateUI(mainmenu.inputHandler.get_node("Attributes"))
	elif inventoryindex == 1:
		slotting = true
		spellindex = 1
		var parentname = "Equiped/Spell" + str(spellindex)
		selector.get_parent().remove_child(selector)
		get_node(parentname).add_child(selector)
	elif inventoryindex == 2:
		inventory.equipmentCards[itemindex - 1].equip(equipments)
		
	atualizeInventory()
	atualizeEquipments(equipments)
	atualizeStats()

func atualizeEquipments(equipments):
	if equipments.mainhand:
		mainhand.texture = equipments.mainhand.texture
	else:
		mainhand.texture = null
	if equipments.offhand:
		offhand.texture = equipments.offhand.texture
	else:
		offhand.texture = null
	if equipments.helmet:
		helmet.texture = equipments.helmet.texture
	else:
		helmet.texture = null
	if equipments.armor:
		armor.texture = equipments.armor.texture
	else:
		armor.texture = null
	if equipments.boots:
		boots.texture = equipments.boots.texture
	else:
		boots.texture = null
	if equipments.spell1:
		spell1.texture = equipments.spell1.texture
	else:
		spell1.texture = null
	if equipments.spell2:
		spell2.texture = equipments.spell2.texture
	else:
		spell2.texture = null
	if equipments.spell3:
		spell3.texture = equipments.spell3.texture
	else:
		spell3.texture = null
	if equipments.spell4:
		spell4.texture = equipments.spell4.texture
	else:
		spell4.texture = null

func atualizeStats():
	var playerStats = mainmenu.inputHandler.get_node("Attributes")
	healthvalue.text = str(playerStats.hp)
	manavalue.text = str(playerStats.mana)
	attackvalue.text = str(playerStats.attack)
	magicattackvalue.text = str(playerStats.magicattack)
	defensevalue.text = str(playerStats.defense)
	magicdefensevalue.text = str(playerStats.magicdefense)
	criticalchancevalue.text = str(playerStats.critChance)
	dodgevalue.text = str(playerStats.dodge)
