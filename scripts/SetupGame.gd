extends Node2D

var game_data
export var save_filename = "res://save.tres"

func _ready():
	game_data = load_save_data(save_filename)
	
	game_data.death_count = 0
	
#	save_data(filename, game_data)
	var error_code = ResourceSaver.save(save_filename, game_data)
	if (error_code != 0):
		print_debug("ERROR:", error_code)
	
	error_code = get_tree().change_scene("res://scenes/World.tscn")
	if (error_code != 0):
		print_debug("ERROR:", error_code)


func load_save_data(file_name = "res://save.tres"):
	if ResourceLoader.exists(file_name):
		var data = ResourceLoader.load(file_name)
		if data is save_data: # Check that the data is valid
			return data
		else:
			print_debug("ERROR: Data file is wrong type")
	else:
		print_debug("ERROR: File not found")
