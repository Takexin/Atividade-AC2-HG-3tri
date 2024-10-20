extends KinematicBody2D

const speed = 1
signal damage
var canDamage = true
onready var timer = get_node("Timer")
export var health = 100

func move_towards_player(player_position, delta, player):
	var direction = (player_position - position).normalized()
	var collision = move_and_collide(direction * speed, delta)
	if(collision and canDamage and (collision.get_collider() == player)):
		emit_signal("damage")
		canDamage = false
		timer.start(1)
func _process(delta):
	var player = get_parent().get_node("character")
	if player:
		move_towards_player(player.position, delta, player)
	#if get_tree().get_root().get_node("main/projectileContainer").get_children():
	#	for child in get_tree().get_root().get_node("main/projectileContainer").get_children():
	#		if(!child.is_connected("projectileDamage",self, "_on_projectile_projectileDamage")):
	#			child.connect("projectileDamage", self, "_on_projectile_projectileDamage")

func _on_projectile_projectileDamage():
	health-=30
	if health <=0:
		self.queue_free()

func _on_Timer_timeout():
	canDamage = true


func _on_Area2D_body_entered(body):
	var projectileName = "projectile"
	if body.get_name().substr(0, projectileName.length()) == projectileName:
		body.queue_free()
		health-=30
		if health <=0:
			self.queue_free()
