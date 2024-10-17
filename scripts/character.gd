extends KinematicBody2D

var health = 3
const SPEED = 15000
onready var timer = get_node("Timer")
onready var timer2 = get_node("Timer2")
onready var sprite = get_node("Sprite")


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
	if(Input.is_action_pressed("restart")):
		get_tree().reload_current_scene()

func _on_Enemy_damage():
	
	health -= 1
	print("damage taken")
	blinc(10)
	if (health == 0):
		get_tree().reload_current_scene()
		print("YOU DIED")


var blincConrol = 0
var numLoops = 0
func blinc(numloops):
	numLoops = numloops
	if(blincConrol <= numloops):
		sprite.modulate = Color(255,255,255)
		timer.start(0.1)
	elif(blincConrol == numloops):
		blincConrol = 0
		numLoops = 0

func _on_Timer_timeout():
	sprite.modulate = Color(1,1,1)
	blincConrol+=1
	timer2.start(0.05)
	


func _on_Timer2_timeout():
	blinc(numLoops)
