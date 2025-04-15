extends Actor
#extends KinematicBody2D

#var input_direction = Vector2.ZERO

onready var platform_detector = $PlatformDetector
onready var animation_player = $AnimationPlayer
onready var sprite = $Sprite
onready var sound_jump = $Jump
onready var sound_die = $Die
onready var sound_fall = $Fall
onready var sound_reset = $Reset

var has_control = true
var dead = false
var celebrate = false

var frames_since_on_ground = -1
var forgiveness_frames = 4 # Number of frames after being on ground that player can still jump

const FLOOR_DETECT_DISTANCE = 20.0

signal player_died


func _ready():
	add_to_group("player")
#	get_parent()
	var error_code = connect("player_died", get_parent(), "player_died")
	if (error_code != 0):
		print_debug("ERROR:", error_code)


func get_direction():
	if (!has_control): return Vector2.ZERO
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		-1 if frames_since_on_ground <= forgiveness_frames and Input.is_action_just_pressed("jump") else 0
#		-1 if is_on_floor() and Input.is_action_just_pressed("jump") else 0
	)


func _physics_process(_delta):
#	print("yeah")
	if (is_on_floor()):
		frames_since_on_ground = 0
	else:
		frames_since_on_ground += 1
	
	
	var direction = get_direction()
	
	if (Input.is_action_just_pressed("reset")):
		reset()
	
	# Play jump sound
	if (direction.y == -1):
		sound_jump.play()
	
#	var snap_vector = Vector2.ZERO
#	if (direction.y == 0):
#		snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE
#	var is_on_platform = platform_detector.is_colliding()
	
	var is_jump_interrupted = Input.is_action_just_released("jump") && _velocity.y < 0
#	_velocity = calculate_move_velocity(_velocity, direction, move_speed, is_jump_interrupted)
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	
#	print(_velocity)
#	_velocity = move_and_slide_with_snap(_velocity, snap_vector, FLOOR_NORMAL, !is_on_platform, 4, 0.9, false)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	
	# switch sprite direction
	if direction.x != 0:
		if direction.x > 0:
			sprite.scale.x = 1
		else:
			sprite.scale.x = -1
	
	var animation = get_new_animation()
	if animation != animation_player.current_animation:
		animation_player.play(animation)


# This function calculates a new velocity whenever you need it.
# It allows you to interrupt jumps.
func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		# Decrease the Y velocity by multiplying it, but don't set it to 0
		# as to not be too abrupt.
		velocity.y *= 0.6
	return velocity


func get_new_animation():
	var animation_new = ""
	if is_on_floor():
		if abs(_velocity.x) > 0.1:
			animation_new = "run"
		else:
			if (!dead):
				if (!celebrate):
					animation_new = "idle"
				else:
					animation_new = "celebrate"
			else:
				animation_new = "dead"
	else:
		if _velocity.y > 0:
			if (!dead):
				animation_new = "falling"
			else:
				animation_new = "deathfall"
		else:
			animation_new = "jumping"
	return animation_new


func reset():
	kill(2)


func kill(code = 0):
	if (dead): return # you only die once
#	if (!celebrate):
	emit_signal("player_died", code)
	has_control = false
	dead = true
	
	match code:
		0:
			# Die
			sound_die.play()
		1:
			# Fall
			sound_fall.play()
		2:
			#Reset
			sound_reset.play() # What a failure


func goal_reached():
	celebrate = true
