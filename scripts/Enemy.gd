extends KinematicBody2D

const speed = 1
signal damage
var canDamage = true
onready var timer = get_node("Timer")

func move_towards_player(player_position, delta):
	var direction = (player_position - position).normalized()
	var collision = move_and_collide(direction * speed, delta)
	if(collision and canDamage):
		emit_signal("damage")
		canDamage = false
		timer.start(0.5)
func _process(delta):
	var player = get_parent().get_node("character")
	if player:
		move_towards_player(player.position, delta)


func _on_Timer_timeout():
	canDamage = true
