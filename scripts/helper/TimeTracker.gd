extends Timer

export var update_interval = 1.0 #how often the timer updates

var elapsed_time: float = 0.0
var time_label: Label # Set by World script

var format_string = ": %d"

func _ready():
	# Connect the timeout signal to a custom method
	var error_code = self.connect("timeout", self, "_on_timeout")
	if (error_code != 0):
		print_debug("ERROR: ", error_code)
	
	# Setup timer update interval
	self.wait_time = update_interval

func _on_timeout():
	# Increment the elapsed time by the wait time
	elapsed_time += wait_time
	
	# Update the label with the formatted time
#	time_label.text = format_string % elapsed_time


func reset_timer():
	# Reset the elapsed time and start the timer
	elapsed_time = 0.0
	time_label.text = format_string % elapsed_time
