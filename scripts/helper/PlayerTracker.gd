extends Node

var username : String

const levelOneKey : String = "vl_one"
const levelTwoKey : String = "vl_two"

# Get the current system username in Godot
func get_system_username() -> String:
	var new_username := ""

	# Try common environment variables for different OSes
	var possible_vars = ["USERNAME", "USER", "LOGNAME"]
	for var_name in possible_vars:
		new_username = OS.get_environment(var_name)
		if new_username != "":
			# Convert username to standard "First L." format
			var split_name = new_username.split("_", false, 3)
			split_name[1] = split_name[1].substr(0, 1)
			var temp = capitalize_first_char(split_name[0]) + " " + capitalize_first_char(split_name[1]) + "."
			new_username = temp
			break
		

	# Fallback if nothing found
	if new_username == "":
		new_username = "Player"

	print("Current username: ", new_username)
	return new_username


# Capitalize the first character of a string in Godot
func capitalize_first_char(text: String) -> String:
	if text.is_empty():
		return ""  # Handle empty string safely

	# Take first character, convert to uppercase, then append the rest
	var first_char := text.substr(0, 1).to_upper()
	var rest := text.substr(1)
	return first_char + rest


# Submit Score
func submit_score(uname : String, score: int):
	var response = await LL_Leaderboards.SubmitScore.new(levelOneKey, score, uname, uname).send()
	if(!response.success) :
		# Request failed, handle errors
		print("Request failed")
	else:
		# Request succeeded, use response as applicable in your game logic
		print("Request success")
