extends CharacterBody2D

signal speed_changed

@export var max_speed = 500
@export var acceleration = 500
@export var deceleration = 500
@export var friction = 100
@export var rotation_speed = 6

var speed = 0:
	set(value):
		if (speed == value): 
			return
		speed = value
		speed_changed.emit(speed)
		
var accelerating = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var accelerate_str = Input.get_action_strength("accelerate")
	var decelerate_str = Input.get_action_strength("decelerate")
	var rotate_left_str = Input.get_action_strength("rotate_left")
	var rotate_right_str = Input.get_action_strength("rotate_right")
	
	var velocity_str = accelerate_str - decelerate_str
	var rotation_str = rotate_right_str - rotate_left_str
	var direction = Vector2(cos(rotation), sin(rotation))
	
	if velocity_str == 0:
		speed = max(0, speed - (delta * friction))
		if accelerating: 
			$AnimationPlayer.play_backwards("accelerate")
		accelerating = false
	elif velocity_str > 0:
		speed = max(0, min(max_speed, speed + ((acceleration - friction) * velocity_str * delta)))
		if not accelerating: 
			$AnimationPlayer.play("accelerate")
		accelerating = true
	elif velocity_str < 0:
		speed = max(0, speed - ((deceleration - friction) * delta))
		if accelerating: 
			$AnimationPlayer.play_backwards("accelerate")
		accelerating = false
		
	velocity = direction * speed
	rotation += rotation_str * rotation_speed * delta
	
	move_and_slide()
