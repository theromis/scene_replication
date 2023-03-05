extends Node


func _ready() -> void:
	if multiplayer.is_server():
		multiplayer.peer_connected.connect(_on_network_peer_connected)

func _exit_tree() -> void:
	if multiplayer.is_server():
		multiplayer.peer_connected.disconnect(_on_network_peer_connected)

@rpc
func _check_client_version(_host_client_version: String) -> void:
	print("_check_client_version autoload")

func _on_network_peer_connected(peer_id: int) -> void:
	_check_client_version.rpc_id(peer_id, "123")
