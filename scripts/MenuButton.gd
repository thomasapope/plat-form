extends Button


export var action = "change_scene"
export var scene = ""
# change_scene
# switch_scene
# exit

func _ready():
	connect("pressed", self, "_on_pressed")


func _on_pressed():
	match action:
		"change_scene":
			var error_code = get_tree().change_scene(scene)
			if (error_code != 0):
				print_debug("ERROR:", error_code)
		"switch_scene":
			pass
		"exit":
			get_tree().quit()
		_:
			print_debug("ERROR: Invalid button action")
