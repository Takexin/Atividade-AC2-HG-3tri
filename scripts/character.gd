extends KinematicBody2D

const SPEED = 15000
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var velocity = Vector2()
	if(Input.is_action_pressed("keyUp")):
		velocity.y = -1* SPEED
	if(Input.is_action_pressed("keyDown")):
		velocity.y = 1 * SPEED
	if(Input.is_action_pressed("keyLeft")):
		velocity.x = -SPEED
	if(Input.is_action_pressed("keyRight")):
		velocity.x = SPEED
	move_and_slide(velocity * delta)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
