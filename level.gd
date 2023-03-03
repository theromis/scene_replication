extends Node3D

const SPAWN_RANDOM := 5.0
var Player = preload("res://player.tscn")
var Sphere = preload("res://sphere.tscn")

var sphere_count = 0

func _ready():
	# We only need to spawn players on the server.
	if not multiplayer.is_server():
		return

	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)

	# Spawn already connected players
	for id in multiplayer.get_peers():
		add_player(id)

	# Spawn the local player unless this is a dedicated server export.
	if not OS.has_feature("dedicated_server"):
		add_player(1)


func _exit_tree():
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_player)


func add_player(id: int):
	var character = Player.instantiate()
	# Set player id.
	character.player = id
	# Randomize character position.
	var pos := Vector2.from_angle(randf() * 2 * PI)
	character.position = Vector3(pos.x * SPAWN_RANDOM * randf(), 1.0, pos.y * SPAWN_RANDOM * randf())
	character.name = str(id)
	$Players.add_child(character, true)

	var sphere = Sphere.instantiate()
	#instantiate in front and up of the player
	sphere.position = character.position + Vector3.FORWARD + Vector3.UP
	$Objects.add_child(sphere, true)
	character.jump_ball.connect(_on_jump_ball.bind(sphere))

func del_player(id: int):
	var character := $Players.get_node_or_null(str(id))
	if character:
		character.jump_ball.disconnect(_on_jump_ball)
		character.queue_free()

func _on_jump_ball(sphere):
	sphere.jump()
