extends ScrollContainer

var label = preload("res://scenes/menu/LeaderboardLabel.tscn")
@export var filepath = "res://victors.txt"
@export var leaderboard_key = 0

var score_format = "%s %7.3fs"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_scores()
	#var victors = load("res://resources/VictorsList.tres").victors
	#for i in range(victors.size()):
		#var new_label = label.instantiate()
##		new_label.text = victors[i]
		#new_label.text = score_format % [victors[i][0], victors[i][1]]
		#add_child(new_label)



func load_scores():
	var count : int = 20

	var response = await LL_Leaderboards.GetScoreList.new(PlayerTracker.LEVEL_KEY[leaderboard_key], count).send()
	if(!response.success) :
		# Request failed, handle errors
		pass
	else:
		# Request succeeded, use response as applicable in your game logic
		if response.items.size() == 0:
		# If there are no scores, delete this level
			queue_free()
			
		for i in range(response.items.size()):
			# Create score labels
			var score = response.items[i].score / 10000.0
			var uname = response.items[i].metadata
			
			# Create a new label for the score
			var new_label = label.instantiate()
			new_label.text = score_format % [uname, score]
			$VBoxContainer/Scores.add_child(new_label)
