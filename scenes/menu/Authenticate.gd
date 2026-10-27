extends Control

var game_data
@export var save_filename = "user://save1.tres"

func _ready():
	# Setup save system
	setup_game()
	
	# Authenticate with LootLocker
	if(!PlayerTracker.has_authenticated):
		PlayerTracker.has_authenticated = true
		var playerIdentifier = PlayerTracker.get_system_username()
		PlayerTracker.username = playerIdentifier
		var guestLoginResponse = await LL_Authentication.GuestSession.new(playerIdentifier).send()
		if(!guestLoginResponse.success) :
			printerr("Guest login failed with reason: " + guestLoginResponse.error_data.to_string())
			return
	


func setup_game():
	game_data = load_save_data(save_filename)
	
	game_data.death_count = 0
	
	var error_code = ResourceSaver.save(game_data, save_filename) 
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
