extends Node

var username : String

const levelOneKey : String = "vl_one"
const levelTwoKey : String = "vl_two"

func _ready():
	username = get_system_username()


# Get the current system username in Godot
func get_system_username() -> String:
	var new_username := ""

	# Try common environment variables for different OSes
	var possible_vars = ["USERNAME", "USER", "LOGNAME"]
	for var_name in possible_vars:
		new_username = OS.get_environment(var_name)
		if new_username != "":
			break

	# Fallback if nothing found
	if new_username == "":
		new_username = "Player"

	print("Current username: ", new_username)
	return new_username
	
	
# Submit Score
func submit_score(uname : String, score: int):
	var response = await LL_Leaderboards.SubmitScore.new(levelOneKey, score, uname, uname).send()
	if(!response.success) :
		# Request failed, handle errors
		print("Request failed")
	else:
		# Request succeeded, use response as applicable in your game logic
		print("Request success")
