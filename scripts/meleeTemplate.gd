extends Node2D
onready var player = get_parent().get_node(".")
var projectileScene = load("res://scenes/weakpons/projectile.tscn")

export var weaponCooldown:float = 0
var isLookingAt = false
var lookAtPos = Vector2(0,0)
var lookAtNode = Node2D
var canShoot = true
var enemyQueue = []
func _ready():
	pass
func attack(body: Node):
	if canShoot and body:
		$AnimationPlayer.play("swing")
		$Sprite.visible = true
		$Sprite/SpriteArea2D.monitoring = true
		canShoot = false
		$shootCooldown.start(weaponCooldown)
	else:
		isLookingAt = false
func _on_shootCooldown_timeout():
	
	canShoot=true
	attack(lookAtNode)

func _process(delta):
	look_at(lookAtPos)
	if player:
		if(lookAtPos < player.position and canShoot == false):
			$Sprite.scale.y = -3
		else:
			$Sprite.scale.y = 3
func lookAt(body: Node2D):
	if body:
		isLookingAt = true
		lookAtPos = body.position
		lookAtNode = body
		attack(body)
	else: 
		isLookingAt = false
		
func _on_Area2D_body_entered(body):
	var enemyName = "Enemy"
	if body.get_name().substr(0, enemyName.length()) == enemyName:
		enemyQueue.push_back(body)
		lookAt(enemyQueue.front())

func _on_Area2D_body_exited(body):
	enemyQueue.erase(body)

func _on_SpriteArea2D_body_entered(body):
	if body.is_in_group("enemy"):
		print("found enemy")
		body.takeDamage()


func _on_AnimationPlayer_animation_finished(anim_name):
	
	$Sprite/SpriteArea2D.monitoring = false
	$AnimationPlayer.stop()
	$Sprite.visible = false
	$Sprite.frame = 2
