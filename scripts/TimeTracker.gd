extends Timer

var elapsed_time: float = 0.0
onready var time_label: Label = $Path/To/Your/Label

func _ready():
	# Connect the timeout signal to a custom method
	self.connect("timeout", self, "_on_timeout")
	# Start the timer with a 1-second interval
	self.wait_time = 1.0
	self.start()

func _on_timeout():
	# Increment the elapsed time by the wait time
	elapsed_time += wait_time
	# Update the label with the formatted time
	time_label.text = "Elapsed time: " + str(floor(elapsed_time))
	
	# Add save functionality here

func reset_timer():
	# Reset the elapsed time and start the timer
	elapsed_time = 0.0
	time_label.text = "Elapsed time: 0"
	start()
