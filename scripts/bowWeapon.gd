extends Node2D
onready var player = get_tree().get_root().get_node("Core/main/character")
var projectileScene = preload("res://scenes/weakpons/projectile.tscn")

export var weaponCooldown: float = 1
var isLookingAt = false
var lookAtPos = Vector2(0, 0)
var lookAtNode = Node2D
var canShoot = true
var enemyQueue = []
func _ready():
	pass


func shoot(body: Node):
	if canShoot and body:
		$AudioStreamPlayer2D.play()
		var projectileInstance = projectileScene.instance()
		projectileInstance.set_name("projectile")
		projectileInstance.direction = (body.position - player.position).normalized()
		#get_tree().get_root().get_node("Core/main/projectileContainer").add_child(projectileInstance, true)
		look_at((body.position - player.position).normalized())
		yield(get_tree().create_timer(0.01), "timeout")
		get_tree().get_root().get_node("Core/main/projectileContainer").call_deferred("add_child", projectileInstance, true)
		canShoot = false
		$shootCooldown.start(weaponCooldown)

	elif(!body):
		lookAt(enemyQueue.front())
	else:
		isLookingAt = false
func _on_shootCooldown_timeout():
	canShoot = true
	lookAt(lookAtNode)

func _process(_delta):

	$anchor.look_at(lookAtPos)
	if (lookAtPos < player.position):
		$anchor/Sprite.scale.y = -2
	else:
		$anchor/Sprite.scale.y = 2
func lookAt(body: Node2D):
	if body:
		isLookingAt = true
		lookAtPos = body.position
		lookAtNode = body
		shoot(body)
	else:
		isLookingAt = false
		if enemyQueue.front():
			lookAt(enemyQueue.front())
		
func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		enemyQueue.push_back(body)
		lookAt(enemyQueue.front())

func _on_Area2D_body_exited(body):
	enemyQueue.erase(body)
