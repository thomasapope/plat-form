extends Node2D

var score_format = "%s %7.3fs"

func _ready():
	
	# Authenticate with LootLocker
	var playerIdentifier = await PlayerTracker.username
	print (playerIdentifier)
	var guestLoginResponse = await LL_Authentication.GuestSession.new(playerIdentifier).send()
	if(!guestLoginResponse.success) :
		printerr("Guest login failed with reason: " + guestLoginResponse.error_data.to_string())
		return
	#submit_score(playerIdentifier)
	# Load Scores
	load_scores()
	
	var victors = load("res://resources/VictorsList.tres").victors
	for i in range(victors.size()):
		var uname = victors[i][0]
		var score = victors[i][1]
		score = score * 10000
		
		#print(score_format % [uname, score])
		 
		#submit_score(uname, score)


# Get the current system username in Godot
func get_system_username() -> String:
	var username := ""

	# Try common environment variables for different OSes
	var possible_vars = ["USERNAME", "USER", "LOGNAME"]
	for var_name in possible_vars:
		username = OS.get_environment(var_name)
		if username != "":
			break

	# Fallback if nothing found
	if username == "":
		username = "Player"

	#print("Current username:", username)
	return username
	
	
# Submit Score
func submit_score(uname : String, score: int):
	var leaderboardKey : String = PlayerTracker.leaderboardKey

	var response = await LL_Leaderboards.SubmitScore.new(leaderboardKey, score, uname, uname).send()
	if(!response.success) :
		# Request failed, handle errors
		print("Request failed")
	else:
		# Request succeeded, use response as applicable in your game logic
		print("Request success")

func load_scores():
	var count : int = 20

	var response = await LL_Leaderboards.GetScoreList.new(PlayerTracker.leaderboardKey, count).send()
	if(!response.success) :
		# Request failed, handle errors
		pass
	else:
		# Request succeeded, use response as applicable in your game logic
		for i in range(response.items.size()):
			var score = response.items[i].score
			var uname = response.items[i].metadata
			print(score_format % [uname, score])
		pass
