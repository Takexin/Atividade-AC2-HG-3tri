extends KinematicBody2D

export var speed = 2
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
		$Sprite.scale.x = 3
		$CPUParticles2D.gravity.x = 50
	elif player.position.x > position.x:
		$Sprite.scale.x = -3
		$CPUParticles2D.gravity.x = -50
var canDie = true
func _on_Timer_timeout():
	canDamage = true
func takeDamage(isPoison: bool = false, damage = 30):
	$AudioStreamPlayer2D.play(0.4)
	health -= damage
	if !isPoison:
		position -= direction * 30
	$Sprite.modulate = Color(255, 255, 255)
	$Damageflicker.start(0.1)
	if health <= 0 and canDie:
		get_tree().get_root().get_node("Core/main").enemyCounter -= 1
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
		$AudioStreamPlayer2D.pitch_scale = 0.7
		$AudioStreamPlayer2D.volume_db = 10
		$AudioStreamPlayer2D.play(0.4)
		visible = false
		$CollisionShape2D.disabled = true
		yield(get_tree().create_timer(0.4), "timeout")
		queue_free()

func poison():
	var i = 0
	var currentSpeed = speed
	speed = 0.2
	while i < 4:
		#$poisonTimer.start(1)
		takeDamage(true, 10)
		yield(get_tree().create_timer(1), "timeout")
		i += 1
	speed = currentSpeed
func _on_poisonTimer_timeout():
	var function = poison()
	takeDamage(true, 10)
	function.resume()

func _on_Damageflicker_timeout():
	$Sprite.modulate = Color(1, 1, 1)
