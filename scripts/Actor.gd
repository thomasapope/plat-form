#Actor.gd
class_name Actor
extends KinematicBody2D

export var speed = Vector2(150, 350) #run, jump
export var air_speed = Vector2(50, 350)
onready var gravity = ProjectSettings.get("physics/2d/default_gravity")

const FLOOR_NORMAL = Vector2.UP

var _velocity = Vector2.ZERO

func _physics_process(delta):
	_velocity.y += gravity * delta
