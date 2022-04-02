extends Area2D

var player
var steps = 1
export(Array, PackedScene) var monsters
export(Array, int) var monsterChance

onready var combatScene = get_tree().root.get_node("Game/Combat")
onready var ui = get_tree().root.get_node("Game/UserInterface/UI")

func _process(delta):
	if player != null:
		if player.velocity != Vector2.ZERO and !player.hasTalisman:
			steps -= 1
	
	if steps <= 0:
		steps = randi()%30000 + 500
		player.action = InputHandler.STATE.Occupied
		randomize()
		var monsterList = []
		for n in randi()%4 + 1:
			var monsterPercentage = randi()%100 + 1
			var counter = 0
			
			for chance in monsterChance:
				if monsterPercentage > chance:
					counter += 1
				
			monsterList.append(monsters[counter])
		
		combatScene.activateCombat(monsterList, player)

func _on_DangerZone_body_entered(body):
	player = body
	ui.dangerSign.modulate.a = 1
	randomize()
	steps = randi()%30000 + 500

func _on_DangerZone_body_exited(body):
	ui.dangerSign.modulate.a = 0.5
	player = null
