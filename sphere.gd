extends RigidBody3D


func despawn():
	get_parent().remove_child(self)
	queue_free()

func jump():
	linear_velocity = Vector3.UP * 10.0

func _on_body_entered(body):
	pass
#	var players_count = $"../../Players".get_child_count()
#	print("_on_body_entered: ", multiplayer.is_server(), " | ", players_count, " | ", body)
#	if multiplayer.is_server() and players_count>1:
#		call_deferred("despawn")
