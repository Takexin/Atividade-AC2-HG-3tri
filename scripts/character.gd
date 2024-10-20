extends KinematicBody2D

var health = 3
const SPEED = 15000
onready var timer = get_node("Timer")
onready var timer2 = get_node("Timer2")
onready var sprite = get_node("Sprite")
func _ready():
	pass
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
	if(velocity.x > 0):
		$AnimationPlayer.play("walk")
		$Sprite.scale.x = 2.5
	elif(velocity.x < 0):
		$AnimationPlayer.play("walk")
		$Sprite.scale.x = -2.5
	if(velocity.y != 0 and velocity.x ==0):
		$AnimationPlayer.play("walk")
	elif(velocity == Vector2(0,0)):
		$AnimationPlayer.stop()
		$Sprite.frame = 1
	if(Input.is_action_pressed("restart")):
		get_tree().reload_current_scene()
var blincControl = 0
var numLoops = 2

func _on_Enemy_damage():
	
	health -= 1
	print("damage taken")
	blinc()
	if (health == 0):
		get_tree().reload_current_scene()
		print("YOU DIED")

func shoot():
	$Timer2.start(1)
func blinc():
	sprite.modulate = Color(255,255,255)
	timer.start(0.1)
func _on_Timer_timeout():
	sprite.modulate = Color(1,1,1)


