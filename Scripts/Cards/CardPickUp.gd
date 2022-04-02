extends StaticBody2D

export(PackedScene) var card
export(int) var amount
export(int) var id
var pickable = true

func _ready():
	if GarbageCollector.pickedCardsId.has(id):
		queue_free()

func interact(player):
	if pickable:
		GarbageCollector.get("pickedCardsId")[id] = ""
		pickable = false
		$AnimatedSprite.play("pickUp")
		var newCard = card.instance()
		player.get_node("Inventory").addItem(newCard, amount)

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "pickUp":
		queue_free()

func _on_Area2D_body_entered(body):
	body.interactionObj = self

func _on_Area2D_body_exited(body):
	body.interactionObj = null
