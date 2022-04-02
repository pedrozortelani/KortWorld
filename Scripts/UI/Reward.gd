extends Control

onready var rewardInfo = get_node("Background/RewardInfo")

var active = false
var player

func _process(delta):
	if active:
		if Input.is_action_just_pressed("ui_accept"):
			active = false
			player.action = InputHandler.STATE.Idle
			visible = false

func applyReward(playerStats, playerInventory, reward):
	rewardInfo.text = "+ " + str(reward[0]) + " EXP\n" 
	for i in reward.size():
		if i == 0:
			continue
		
		var newcard = reward[i].instance()
		playerInventory.addItem(newcard, 1)
		rewardInfo.text += newcard.name + "\n"
	
	player = playerStats.get_parent()
	player.action = InputHandler.STATE.Talking
	visible = true
	active = true
