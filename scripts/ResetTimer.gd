extends Timer

var is_holding_reset = false
export var hold_time = 2.0  # Time to hold the key to reset (in seconds)
var hold_timer = 0.0  # Tracks how long the key has been held

# Reference to the UI ProgressBar
onready var reset_progress_bar = $ResetProgress

func _process(delta):
	if Input.is_action_pressed("reset"):
		if !is_holding_reset:
			is_holding_reset = true
			hold_timer = 0.0
			reset_progress_bar.visible = true
		else:
			hold_timer += delta
			reset_progress_bar.value = (hold_timer / hold_time) * 100  # Update progress bar
			if hold_timer >= hold_time:
				reset_character()
				reset_progress_bar.value = 0  # Reset progress bar
	else:
		if is_holding_reset:
			is_holding_reset = false
			hold_timer = 0.0
			reset_progress_bar.value = 0  # Reset progress bar
			reset_progress_bar.visible = false

func reset_character():
	get_parent().reset()
