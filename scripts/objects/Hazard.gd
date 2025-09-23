extends Area2D


func _ready():
	var error_code = connect("body_entered", self, "_on_body_entered")
	if (error_code != 0):
		print_debug("ERROR:", error_code)


func _on_body_entered(body):
	if (body.is_in_group("player")):
		body.kill()
