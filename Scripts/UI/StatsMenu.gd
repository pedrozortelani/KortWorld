extends Control

var playerStats

onready var userInterface = get_tree().root.get_node("Game/UserInterface/UI")

onready var strBtn = get_node("PrimaryStats/StrBtn")
onready var intBtn = get_node("PrimaryStats/IntBtn")
onready var staBtn = get_node("PrimaryStats/StaBtn")
onready var dexBtn = get_node("PrimaryStats/DexBtn")

onready var level = get_node("Level")

onready var hpbar = get_node("Bars/HPBar")
onready var manabar = get_node("Bars/ManaBar")
onready var expbar = get_node("Bars/EXPBar")

onready var strength = get_node("PrimaryStats/StrengthValue")
onready var inteligence = get_node("PrimaryStats/InteligenceValue")
onready var stamina = get_node("PrimaryStats/StaminaValue")
onready var dexterity = get_node("PrimaryStats/DexterityValue")
onready var statPoints = get_node("PrimaryStats/StatPointsValue")

onready var health = get_node("SecundaryStats/HealthValue")
onready var mana = get_node("SecundaryStats/ManaValue")
onready var attack = get_node("SecundaryStats/AttackValue")
onready var magicattack = get_node("SecundaryStats/MagicAttackValue")
onready var defense = get_node("SecundaryStats/DefenseValue")
onready var magicdefense = get_node("SecundaryStats/MagicDefenseValue")
onready var critchance = get_node("SecundaryStats/CriticalChanceValue")
onready var dodge = get_node("SecundaryStats/DodgeValue")

var active = false
var mainmenu

func _process(delta):
	if active:
		if Input.is_action_just_pressed("ui_cancel"):
			visible = false
			active = false
			mainmenu.index = 0;
			mainmenu.statsBtn.grab_focus()

func atualizeUI():
	level.text = "Level " + str(playerStats.level)
	
	hpbar.max_value = playerStats.hp
	hpbar.value = playerStats.currentHp
	manabar.max_value = playerStats.mana
	manabar.value = playerStats.currentMana
	expbar.max_value = playerStats.level * playerStats.level * 10
	expbar.value = playerStats.experience
	
	strength.text = str(playerStats.strength)
	inteligence.text = str(playerStats.inteligence)
	stamina.text = str(playerStats.stamina)
	dexterity.text = str(playerStats.dexterity)
	statPoints.text = str(playerStats.statPoints)

	health.text = str(playerStats.hp)
	mana.text = str(playerStats.mana)
	attack.text = str(playerStats.attack)
	magicattack.text = str(playerStats.magicattack)
	defense.text = str(playerStats.defense)
	magicdefense.text = str(playerStats.magicdefense)
	critchance.text = str(playerStats.critChance)
	dodge.text = str(playerStats.dodge)

func addStat(stat):
	playerStats.statPoints -= 1
	playerStats.set(stat, playerStats.get(stat) + 1)
	
	playerStats.updateStats()
	userInterface.updateUI(playerStats)
	atualizeUI()

func _on_StrBtn_pressed():
	if playerStats.statPoints > 0:
		addStat("strength")


func _on_IntBtn_pressed():
	if playerStats.statPoints > 0:
		addStat("inteligence")


func _on_StaBtn_pressed():
	if playerStats.statPoints > 0:
		addStat("stamina")


func _on_DexBtn_pressed():
	if playerStats.statPoints > 0:
		addStat("dexterity")
