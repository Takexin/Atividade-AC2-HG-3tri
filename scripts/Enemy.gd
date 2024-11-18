# ENEMY TEMPLATE - NOT IN USE AT THE MOMENT

extends KinematicBody2D

const speed = 1
signal damage
var canDamage = true
onready var timer = get_node("Timer")
export var health = 100
var xpScene = load("res://scenes/orbXP.tscn")
var heartScene = load("res://scenes/health.tscn")
var direction
func move_towards_player(player_position, delta, player):
	direction = (player_position - position).normalized()
	var collision = move_and_collide(direction * speed, delta)
	if (collision and canDamage and (collision.get_collider() == player)):
		emit_signal("damage")
		player._on_Enemy_damage()
		canDamage = false
		timer.start(1)
func _process(delta):
	var player = get_parent().get_node("character")
	if player:
		move_towards_player(player.position, delta, player)
	
func _on_Timer_timeout():
	canDamage = true
func takeDamage(isPoison: bool = false, damage = 30):
	health -= damage
	if !isPoison:
		position -= direction * 30
	$Sprite.modulate = Color(255, 255, 255)
	$Damageflicker.start(0.1)
	if health <= 0:
		if (direction < Vector2(1000,1000) and direction > Vector2(-1000,-1000)): 
			if randf() >= 0.8:
				var xpInstance = xpScene.instance()
				xpInstance.position = self.position
				xpInstance.xpAmmount = 3
				xpInstance.set_name("orbXP")
				get_parent().call_deferred("add_child", xpInstance)
		self.queue_free()
func poison():
	var i = 0
	while i < 4:
		$poisonTimer.start(1)
		yield(get_tree().create_timer(1), "timeout")
		takeDamage(true, 10)
		i += 1

func _on_Damageflicker_timeout():
	$Sprite.modulate = Color(1, 1, 1)
