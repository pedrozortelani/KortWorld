extends CanvasLayer

onready var UI = get_node("UI")
onready var textBox = get_node("UI/TextBox")

var textArray = []
var textIndex = 0
var active = false
var textOrigin = null
var playerRef = null

func _process(delta):
	if active:
		if Input.is_action_just_pressed("ui_accept"):
			textIndex += 1
			if textIndex < textArray.size():
				textBox.text = textArray[textIndex]
			else:
				endDialog()

func initializeDialog(player, interactionObj):
	playerRef = player
	player.action = InputHandler.STATE.Talking
	textIndex = 0
	UI.visible = true
	textOrigin = interactionObj
	textArray = interactionObj.textArray
	UI.add_child(textOrigin.get_node("AnimatedSprite").duplicate())
	UI.get_node("AnimatedSprite").position = Vector2(-155, 22)
	textBox.text = textArray[textIndex]
	active = true

func endDialog():
	UI.visible = false
	active = false
	UI.remove_child(UI.get_node("AnimatedSprite"))
	if textOrigin.has_method("activateEvent"):
		textOrigin.activateEvent(playerRef)
