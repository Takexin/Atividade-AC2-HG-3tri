extends KinematicBody2D

export var speed = 1
signal damage
var canDamage = true
var canPlay = true
onready var timer = get_node("Timer")
export var health = 100
var xpScene = load("res://scenes/orbXP.tscn")
var direction
func move_towards_player(player_position, delta, player):
	direction = (player_position - position).normalized()
	var collision = move_and_collide(direction * speed, delta)
	$AnimationPlayer.play("walk")
	if (collision and canDamage and (collision.get_collider() == player)):
		emit_signal("damage")
		player._on_Enemy_damage()
		canDamage = false
		timer.start(1)
func _process(delta):
	var player = get_parent().get_node("character")
	if player:
		move_towards_player(player.position, delta, player)
	if player.position.x < position.x:
		$Sprite.scale.x = -3
	elif player.position.x > position.x:
		$Sprite.scale.x = 3
	
func _on_Timer_timeout():
	canDamage = true
func takeDamage(isPoison: bool = false, damage = 30):
	health -= damage
	$AudioStreamPlayer2D.play()
	if !isPoison:
		position -= direction * 30
	$Sprite.modulate = Color(255, 255, 255)
	$Damageflicker.start(0.1)
	if health <= 0:
		var player = get_parent().get_node("character")
		var xpInstance = xpScene.instance()
		xpInstance.position = self.position
		xpInstance.xpAmmount = 3
		xpInstance.set_name("orbXP")
		player.get_node("Area2D").monitoring = false
		get_parent().call_deferred("add_child", xpInstance)
		yield(get_tree().create_timer(0.01),"timeout")
		player.get_node("Area2D").monitoring = true
		self.queue_free()


func poison():
	var i = 0
	while i < 4:
		$poisonTimer.start(1)
		yield ()
		i += 1
func _on_poisonTimer_timeout():
	var function = poison()
	function.resume()
	takeDamage(true, 10)


func _on_hit_finished():
	$hit.playing = false	




func _on_AudioStreamPlayer2D_finished():
	# $AudioStreamPlayer2D.playing = false
	pass



func _on_Damageflicker_timeout():
	$Sprite.modulate = Color(1, 1, 1)
