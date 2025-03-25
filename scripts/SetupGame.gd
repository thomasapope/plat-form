extends Node2D

var game_data
#export var save_filename = "user://save.tres"
export var save_filename = "user://save1.tres"

func _ready():
	game_data = load_save_data(save_filename)
	
	game_data.death_count = 0
	print ("Setting deaths to 0")
	print(game_data.death_count)
	
#	save_data(filename, game_data)
	var error_code = ResourceSaver.save(save_filename, game_data)
	if (error_code != 0):
		print_debug("ERROR:", error_code)
	
	error_code = get_tree().change_scene("res://scenes/World.tscn")
	if (error_code != 0):
		print_debug("ERROR:", error_code)


func load_save_data(file_name = save_filename):
	if ResourceLoader.exists(file_name):
		var data = ResourceLoader.load(file_name)
		if data is save_data: # Check that the data is valid
			return data
		else:
			print_debug("ERROR: Data file is wrong type")
	else:
		print_debug("ERROR: File not found. Creating new file.")
		var data = save_data.new()
		data.creator_death_count = 0
		
		var error_code = ResourceSaver.save(save_filename, data)
		if (error_code != 0):
			print_debug("ERROR:", error_code)
		return data
