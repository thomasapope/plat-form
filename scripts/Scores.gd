extends VBoxContainer


var label = preload("res://scenes/LeaderboardLabel.tscn")


export var filepath = "res://victors.txt"

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load list of victors
	var victors = ["Charles C.", "Landen R.", "Owen G."]
	
	for i in range(victors.size()):
		var new_label = label.instance()
		new_label.text = victors[i]
		add_child(new_label)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
