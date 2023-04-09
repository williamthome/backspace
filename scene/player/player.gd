extends CharacterBody2D


@export var speed = 300
@export var rotation_speed = 4.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var accelerate_str = Input.get_action_strength("accelerate")
	var decelerate_str = Input.get_action_strength("decelerate")
	var rotate_left_str = Input.get_action_strength("rotate_left")
	var rotate_right_str = Input.get_action_strength("rotate_right")
	var velocity_str = decelerate_str - accelerate_str
	var rotation_str = rotate_right_str - rotate_left_str
	var direction = Vector2(sin(rotation) * -1, cos(rotation))
	velocity = direction * speed * velocity_str
	rotation += rotation_str * rotation_speed * delta
	move_and_slide()
