extends Node

var helmet
var armor
var boots

var mainhand
var offhand

var spell1
var spell2
var spell3
var spell4

func applySetBonus():
	var playerStats = get_parent().get_node("Attributes")
	
	if helmet != null:
		helmet.applyBonus(playerStats)
	if armor != null:
		armor.applyBonus(playerStats)
	if boots != null:
		boots.applyBonus(playerStats)
	if mainhand != null:
		mainhand.applyBonus(playerStats)
	if offhand != null and mainhand != offhand:
		offhand.applyBonus(playerStats)
