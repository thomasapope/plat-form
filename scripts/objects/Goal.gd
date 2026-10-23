extends Area2D

signal goal_reached

func _ready():
	var error_code = connect("body_entered", Callable(self, "_on_body_entered"))
	if (error_code != 0):
		print_debug("ERROR:", error_code)
	error_code = connect("goal_reached", Callable(get_parent(), "goal_reached"))
	if (error_code != 0):
		print_debug("ERROR:", error_code)
	error_code = connect("goal_reached", Callable(get_node("../Character"), "goal_reached"))
	if (error_code != 0):
		print_debug("ERROR:", error_code)


func _on_body_entered(body):
	if (body.is_in_group("player")):
		$Sprite2D.texture = load("res://art/tile_0390.png")
		emit_signal("goal_reached")
