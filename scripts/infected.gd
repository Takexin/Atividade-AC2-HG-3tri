extends KinematicBody2D

export var speed = 1
signal damage
var canDamage = true
var canPlay = true
onready var timer = get_node("Timer")
export var health = 100
var xpScene = load("res://scenes/orbXP.tscn")
var heartScene = load("res://scenes/health.tscn")
var direction

var died = false
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
	
export var canDie = true
func _on_Timer_timeout():
	canDamage = true
func takeDamage(isPoison: bool = false, damage = 30):
	if canDie:
		$AudioStreamPlayer2D.play(0.4)
		health -= damage
		if !isPoison:
			position -= direction * 30
		$Sprite.modulate = Color(255, 255, 255)
		$Damageflicker.start(0.1)
		if health <= 0:
			canDie = false
			var player = get_parent().get_node("character")
			if randf() >= 0.1:
				var xpInstance = xpScene.instance()
				xpInstance.position = self.position
				xpInstance.xpAmmount = 3
				xpInstance.set_name("orbXP")
				player.get_node("Area2D").monitoring = false
				get_parent().call_deferred("add_child", xpInstance)
				yield(get_tree().create_timer(0.01),"timeout")
				player.get_node("Area2D").monitoring = true
			else:
				var xpInstance = heartScene.instance()
				xpInstance.position = self.position
				xpInstance.set_name("orbXP")
				player.get_node("Area2D").monitoring = false
				get_parent().call_deferred("add_child", xpInstance)
				yield(get_tree().create_timer(0.01),"timeout")
				player.get_node("Area2D").monitoring = true
			
			get_tree().get_root().get_node("Core/main").enemyCounter -= 1
			$AudioStreamPlayer2D.pitch_scale = 0.7
			$AudioStreamPlayer2D.volume_db = 10
			$AudioStreamPlayer2D.play(0.4)
			visible = false
			$CollisionShape2D.disabled = true
			yield(get_tree().create_timer(0.6), "timeout")
			self.queue_free()

var i = 0
func poison():
	var speedValue = speed
	while i < 4:
		if canDie:
			speed = 0.2
			$poisonTimer.start(1)
			yield($poisonTimer, "timeout")
			i += 1
	i = 0
	speed = speedValue
func _on_poisonTimer_timeout():
	call_deferred("takeDamage",true,10)


func _on_hit_finished():
	$hit.playing = false




func _on_AudioStreamPlayer2D_finished():
	# $AudioStreamPlayer2D.playing = false
	pass



func _on_Damageflicker_timeout():
	$Sprite.modulate = Color(1, 1, 1)
