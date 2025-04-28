extends VBoxContainer

var label = preload("res://scenes/LeaderboardLabel.tscn")
export var filepath = "res://victors.txt"

# Called when the node enters the scene tree for the first time.
func _ready():
	# Load list of victors from a text file
#	var file = File.new()
#	if file.file_exists(filepath):
#		file.open(filepath, File.READ)
#		var victors = []
#		while not file.eof_reached():
#			var line = file.get_line().strip_edges()
#			if line != "":
#				victors.append(line)
#		file.close()
#
#		for i in range(victors.size()):
#			var new_label = label.instance()
#			new_label.text = victors[i]
#			add_child(new_label)
#	else:
#		print("File not found: %s" % filepath)



#	var file = File.new()
#	if file.file_exists(filepath):
#		file.open(filepath, File.READ)
#		var victors = []
#		while not file.eof_reached():
#			var line = file.get_line().strip_edges()
#			if line != "":
#				victors.append(line)
#		file.close()
	var victors = load("res://VictorsList.tres").victors
	for i in range(victors.size()):
		var new_label = label.instance()
		new_label.text = victors[i]
		add_child(new_label)
