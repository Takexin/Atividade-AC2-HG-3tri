extends Node2D
onready var player = get_tree().get_root().get_node("Core/main/character")
var projectileScene = load("res://scenes/weakpons/projectile.tscn")

export var weaponCooldown:float = 0
var isLookingAt = false
var lookAtPos = Vector2(0,0)
var lookAtNode = Node2D
var canShoot = true
var enemyQueue = []
func _ready():
	pass
var canHit = true
func attack(body: Node):
	if canShoot and body:
		$AnimationPlayer.play("swing")
		$AudioStreamPlayer2D.play(0.1)
		$anchor/Sprite.visible = true
		$anchor/Sprite/SpriteArea2D.monitoring = true
		canShoot = false
		$shootCooldown.start(weaponCooldown)
	else:
		isLookingAt = false
func _on_shootCooldown_timeout():
	
	canShoot=true
	attack(lookAtNode)

func _process(delta):
	$anchor.look_at(lookAtPos)
	if player:
		if(lookAtPos < player.position and canShoot == false):
			$anchor/Sprite.scale.y = -3
		else:
			$anchor/Sprite.scale.y = 3
		
	var bodies = $anchor/Sprite/SpriteArea2D.get_overlapping_bodies()
	for body in bodies:
		if is_instance_valid(body):
			if body.is_in_group("enemy") and canHit:
				body.call_deferred("takeDamage")
				canHit = false
				yield(get_tree().create_timer(0.5),"timeout")
				canHit = true
				
				
				
			
			
	
func lookAt(body: Node2D):
	if body:
		isLookingAt = true
		lookAtPos = body.position
		lookAtNode = body
		attack(body)
	else: 
		isLookingAt = false
		
func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		lookAt(body)
	elif body.is_in_group("xp"):
		body.queue_free()
func _on_Area2D_body_exited(body):
	pass
	
func _on_SpriteArea2D_body_entered(body):
#	if body.is_in_group("enemy"):
#		while body:
#			print("aaaa")
#			yield(get_tree().create_timer(0.3),"timeout")
#			body.takeDamage()
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	
	$anchor/Sprite/SpriteArea2D.monitoring = false
	$AnimationPlayer.stop()
	$anchor/Sprite.visible = false
	$anchor/Sprite.frame = 2
