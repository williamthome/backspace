extends CharacterBody2D

signal speed_changed

@export var max_speed = 500
@export var acceleration = 300
@export var deceleration = 300
@export var friction = 100
@export var rotation_speed = 4

var speed = 0:
	set(value):
		if speed == value: return
		speed = value
		speed_changed.emit(speed)

var accelerate_str: float = 0.0
var decelerate_str: float = 0.0
var rotate_left_str: float = 0.0
var rotate_right_str: float = 0.0
var velocity_str: float = 0.0
var rotation_str: float = 0.0


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action("accelerate"):
		if event.is_pressed():
			accelerate_str = event.get_action_strength("accelerate")
		else:
			accelerate_str = 0
		recalculate_velocity_str()
	elif event.is_action("decelerate"):
		if event.is_pressed():
			decelerate_str = event.get_action_strength("decelerate")
		else:
			decelerate_str = 0
		recalculate_velocity_str()
	elif event.is_action("rotate_left"):
		if event.is_pressed():
			rotate_left_str = event.get_action_strength("rotate_left")
		else:
			rotate_left_str = 0
		recalculate_rotation_str()
	elif event.is_action("rotate_right"):
		if event.is_pressed():
			rotate_right_str = event.get_action_strength("rotate_right")
		else:
			rotate_right_str = 0
		recalculate_rotation_str()


func recalculate_velocity_str() -> void:
	velocity_str = accelerate_str - decelerate_str


func recalculate_rotation_str() -> void:
	rotation_str = rotate_right_str - rotate_left_str


func _physics_process(delta):
	if speed == 0 and velocity_str and rotation_str:
		return
	
	var move_started = false
	
	if velocity_str == 0:
		speed = max(0, speed - (delta * friction))
	elif velocity_str > 0:
		move_started = speed == 0
		speed = max(0, min(max_speed, speed + ((acceleration - friction) * velocity_str * delta)))
	elif velocity_str < 0:
		speed = max(0, speed - ((deceleration - friction) * delta))
	
	rotation += rotation_str * rotation_speed * delta
	
	var direction = Vector2(cos(rotation), sin(rotation))
	velocity = direction * speed
	
	move_and_slide()
	animate(move_started)


func animate(move_started: bool) -> void:
	if move_started:
		$AnimationAccelerate.play("accelerate")
		$AnimationPropulsion.play("propulsion")
	elif speed > 0:
		var seconds = (speed / max_speed) * $AnimationAccelerate.current_animation_length
		$AnimationAccelerate.seek(seconds, true)
	else:
		$AnimationAccelerate.stop()
		$AnimationPropulsion.stop()
