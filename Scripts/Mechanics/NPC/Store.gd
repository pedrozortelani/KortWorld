extends Control

onready var background = get_node("Background")
onready var buySprite = preload("res://Assets/UI/Store/StoreBuy.png")
onready var sellSprite = preload("res://Assets/UI/Store/StoreSell.png")

var active = false
var player = null

func _process(delta):
	if active:
		if Input.is_action_just_pressed("ui_page_down"):
			background.texture = sellSprite
		elif Input.is_action_just_pressed("ui_page_up"):
			background.texture = buySprite
		elif Input.is_action_just_pressed("ui_cancel"):
			closeStore()

func openStore(player):
	self.player = player
	background.texture = buySprite
	visible = true
	active = true

func closeStore():
	visible = false
	active = false
	player.action = InputHandler.STATE.Idle
