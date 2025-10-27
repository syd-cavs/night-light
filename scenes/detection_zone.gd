extends Area2D

signal player_detected(player)
signal player_lost(player)

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		emit_signal("player_detected", body)
	
func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		emit_signal("player_lost", body)
