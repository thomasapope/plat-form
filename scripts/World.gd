extends Node2D

var reset_time = 2
var end_reset_time = 70
var blocks = 6

var is_goal_reached = false

onready var sound_win = $Win
onready var timer = $TimeTracker

var block_format_str = ": %d"
var format_string = ": %d"
var death_count_format_str = ": %d"
var end_death_format = "%d deaths"
var end_best_format = "best: %d"
var end_creator_format = "creator's best: %d"
var time_format = "time: %-3.3f"
var best_time_format = "%d"
var game_data
var death_count = 0
var elapsed_time = 0

export var save_filename = "user://save1.tres"


func _ready():
	$"Camera2D/GUI/GUI/Blocks/Block Label".text = block_format_str % blocks
	
	# Setup reset timer
	var error_code = $ResetTimer.connect("timeout", self, "reset")
	if (error_code != 0):
		print_debug("ERROR:", error_code)
	
	# Setup time tracker
	error_code = timer.connect("timeout", self, "_on_timer_timeout")
	if (error_code != 0):
		print_debug("ERROR:", error_code)
	timer.time_label = $Camera2D/GUI/GUI/Time/TimeLabel
	timer.start()
		
	game_data = load_save_data(save_filename)
#	print (game_data.death_count)
#	print (game_data.creator_death_count)
#	print (game_data.best_death_count)
	
	$Camera2D/GUI/GUI/Deaths/DeathCountLabel.text = death_count_format_str % game_data.death_count
	
	
#	print ("Checking deaths")
#	print(game_data.death_count)


func save_data(filename, data):
	var result = ResourceSaver.save(filename, data)
	assert(result == OK)


func load_save_data(file_name = "res://save_data.tres"):
	if ResourceLoader.exists(file_name):
		var data = ResourceLoader.load(file_name)
		if data is save_data: # Check that the data is valid
			return data
	else:
		print_debug("ERROR: File not found")


func player_died(code):
	get_node("Camera2D/GUI/DeathLabel").visible = true
	if (code == 1):
		get_node("Camera2D/GUI/DeathLabel").text = "and then you fell forever..."
	$ResetTimer.stop()
	$ResetTimer.wait_time = reset_time
	$ResetTimer.start()
	
	# Hide GUI
	$Tutorials.visible = false
	$Camera2D/GUI.visible = false
	
	# Update deaths
	game_data.death_count += 1
	
	# Save game_data
	var error_code = ResourceSaver.save(save_filename, game_data)
	if (error_code != 0):
		print_debug("ERROR:", error_code)


func check_best_time(time = 0):
	if game_data.best_time < 1:
		print("First new time")
		return true
	if time < game_data.best_time:
		print("Best time")
		return true # Best time achieved
	else:
		print("Not best time")
		return false # Not best time


func goal_reached():
	if (is_goal_reached): return
	
	is_goal_reached = true
	sound_win.play()
	
	timer.paused = true
	elapsed_time = elapsed_time + timer.time_left
	
	# Hide GUI
	$Tutorials.visible = false
	$Camera2D/GUI/GUI.visible = false
	
	# Show Victory GUI
	get_node("Camera2D/GUI/VictoryLabel").visible = true
	
	# Time
	get_node("Camera2D/GUI/VictoryLabel/Time").text = time_format % elapsed_time
	# Deaths
	get_node("Camera2D/GUI/VictoryLabel/Deaths").text = end_death_format % game_data.death_count
	get_node("Camera2D/GUI/VictoryLabel/Deaths/Best").text = end_best_format % game_data.best_death_count
	#get_node("Camera2D/GUI/VictoryLabel/Deaths/Best/CreatorBest").text = end_creator_format % game_data.creator_death_count
	
	$ResetTimer.wait_time = end_reset_time
	$ResetTimer.start()
	
	# Check for fewest deaths
	if (game_data.best_death_count > game_data.death_count || game_data.best_death_count == -1):
		game_data.best_death_count = game_data.death_count
		print("NEW HIGH SCORE! ", game_data.best_death_count)
		get_node("Camera2D/GUI/VictoryLabel/Deaths/Best").text = end_best_format % game_data.best_death_count
	
	# Check for best time
	if (check_best_time(elapsed_time)):
		game_data.best_time = elapsed_time
		print("NEW BEST TIME! ", game_data.best_time)
#		$Camera2D/GUI/
	
	var error_code = ResourceSaver.save(save_filename, game_data)
	if (error_code != 0):
		print_debug("ERROR:", error_code)


func take_screenshot():
	# Get the viewport's texture and image data
	var image = get_viewport().get_texture().get_data()
	# Flip the image vertically (necessary for correct orientation)
	image.flip_y()
	# Save the image to a file (e.g., 'user://screenshot.png')
	image.save_png("user://platform_screenshot.png")


func reset():
	if (!is_goal_reached):
		var error_code = get_tree().reload_current_scene()
		if (error_code != 0):
			print_debug("ERROR:", error_code)
	else:
		var error_code = get_tree().change_scene("res://scenes/Setup Game.tscn")
		if (error_code != 0):
			print_debug("ERROR:", error_code)


func _on_timer_timeout():
	# Update elapsed time and time label
	elapsed_time += 1
	$Camera2D/GUI/GUI/Time/TimeLabel.text = format_string % elapsed_time


# Place Blocks
func _unhandled_input(event):
	if (blocks < 1): return
	if ($Character.dead == true): return
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		if event.is_pressed():
			var click_pos = $TileMap.world_to_map(get_global_mouse_position())
#			print("Tilemap Cell: ", click_pos)
			if ($TileMap.get_cellv(click_pos) == -1):
				# Make sure the player is not in that cell
				var player_pos = $TileMap.world_to_map($TileMap.to_local($Character.position))
				if player_pos != click_pos:
					$TileMap.set_cellv(click_pos, 0)
					blocks -= 1
					$"Camera2D/GUI//GUI/Blocks/Block Label".text = block_format_str % blocks
				else:
					print("The player is there.")
			else:
				# Already a block there
				print("There is already a tile there.")


func wait(seconds: float) -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = seconds
	timer.one_shot = true
	timer.start()
	yield(timer, "timeout")
	timer.queue_free()  # Clean up the timer after use
