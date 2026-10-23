extends HBoxContainer

var label = preload("res://scenes/menu/LeaderboardLabel.tscn")
@export var filepath = "res://victors.txt"


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

	var response = await LL_Leaderboards.GetScoreList.new(PlayerTracker.levelOneKey, count).send()
	if(!response.success) :
		# Request failed, handle errors
		pass
	else:
		# Request succeeded, use response as applicable in your game logic
		
		# 
		for i in range(response.items.size()):
			var score = response.items[i].score / 10000.0
			var uname = response.items[i].metadata
			
			# Create a new label for the score
			var new_label = label.instantiate()
			new_label.text = score_format % [uname, score]
			$Level1Container/VBoxContainer/Scores.add_child(new_label)
