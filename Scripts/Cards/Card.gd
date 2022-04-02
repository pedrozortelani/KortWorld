extends Node

class_name Card

enum TYPE{Consumable, Equipment, Spell}

export(int) var price
export(TYPE) var type
export(String, MULTILINE) var description

func sellCard():
	pass
