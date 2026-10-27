extends Button


@export var action = "change_scene_to_file"
@export var scene = ""
# change_scene
# switch_scene
# exit

func _ready():
	var error_code = connect("pressed", Callable(self, "_on_pressed"))
	if (error_code != 0):
		print_debug("ERROR: ", error_code)


func _on_pressed():
	match action:
		"change_scene_to_file":
			var error_code = get_tree().change_scene_to_file(scene)
			if (error_code != 0):
				print_debug("ERROR:", error_code)
		"switch_scene":
			pass
		"exit":
			get_tree().quit()
		_:
			print_debug("ERROR: Invalid button action")
