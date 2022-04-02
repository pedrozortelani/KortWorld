extends Control

onready var healthbar = get_node("Bars/HealthBar")
onready var manabar = get_node("Bars/ManaBar")
onready var expbar = get_node("Bars/ExpBar")
onready var dangerSign = get_node("DangerSign")

func _ready():
	updateUI(get_parent().get_parent().find_node("Player", true, false).get_node("Attributes"))

func updateUI(playerStats):
	healthbar.max_value = playerStats.hp
	healthbar.value = playerStats.currentHp
	manabar.max_value = playerStats.mana
	manabar.value = playerStats.currentMana
	expbar.max_value = playerStats.level * playerStats.level * 10
	expbar.value = playerStats.experience
