extends Node

var consumableCards = []
var consumableAmount = []
var equipmentCards = []
var spellCards = []

func addItem(newCard, amount):
	if newCard.type == Card.TYPE.Consumable:
		var found = false
		for card in consumableCards:
			if card.name == newCard.name:
				found = true
				consumableAmount[consumableCards.find(card)] += amount
		if !found and consumableCards.size() < 20:
			consumableCards.append(newCard)
			consumableAmount.append(amount)
		else:
			destroyCard(newCard)
	elif newCard.type == Card.TYPE.Equipment:
		if equipmentCards.size() < 20:
			equipmentCards.append(newCard)
		else:
			destroyCard(newCard)
	elif newCard.type == Card.TYPE.Spell:
		if spellCards.size() < 20:
			spellCards.append(newCard)
		else:
			destroyCard(newCard)

func destroyCard(card):
	pass
