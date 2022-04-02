extends Node

export(Vector2) var destiny
export(String) var destinyNode

func _on_Area2D_body_entered(body):
	body.position = destiny
	
	if destinyNode == "Map":
		get_parent().get_node("Player/Camera2D").current = true
	else:
		get_parent().get_node(destinyNode + "/Camera2D").current = true
