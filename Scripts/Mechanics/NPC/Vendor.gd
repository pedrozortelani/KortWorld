extends StaticBody2D

onready var store = get_node("CanvasLayer/UI")

export(Array, String) var textArray
export(Array, PackedScene) var itemList

func interact(player):
	get_node("/root/DialogBox").initializeDialog(player, self)

func activateEvent(player):
	store.openStore(player)
	player.interactionObj = null

func _on_Area2D_body_entered(body):
	body.interactionObj = self

func _on_Area2D_body_exited(body):
	body.interactionObj = null
