extends Area2D

export(String) var scenePath
export(Vector2) var entryPosition
export(bool) var shouldFollow
var player = null
var worked = false

func _on_Area2D_body_entered(body):
	if !worked:
		worked = true
		player = body
		
		var newScene = load(scenePath).instance()
		for node in newScene.get_children():
			if node is InputHandler:
				node.get_parent().remove_child(node)
				node.queue_free()
		
		player.remove_child(player.get_node("Camera2D"))
		get_tree().root.get_node("Game").add_child(newScene)
		player.get_parent().remove_child(player)

		newScene.add_child(player)
		newScene.get_node("Camera2D").current = true
		player.position = entryPosition
		
		if shouldFollow:
			var camera = newScene.get_node("Camera2D")
			camera.get_parent().remove_child(camera)
			player.add_child(camera)
			camera.position = Vector2.ZERO
		
		get_parent().get_parent().queue_free()
