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

func shoot(body: Node):
	if canShoot and body:
		var projectileInstance = projectileScene.instance()
		projectileInstance.set_name("projectile")
		projectileInstance.direction = (body.position - player.position).normalized()
		get_tree().get_root().get_node("main/projectileContainer").add_child(projectileInstance,true)
		canShoot = false
		$shootCooldown.start(weaponCooldown)
	else:
		isLookingAt = false
func _on_shootCooldown_timeout():
	canShoot=true
	shoot(lookAtNode)

func _process(delta):
	look_at(lookAtPos)
func lookAt(body: Node2D):
	if body:
		isLookingAt = true
		lookAtPos = body.position
		lookAtNode = body
		shoot(body)
	else: 
		isLookingAt = false
func _on_Area2D_body_entered(body):
	print(enemyQueue)
	var enemyName = "Enemy"
	if body.get_name().substr(0, enemyName.length()) == enemyName:
		enemyQueue.push_back(body)
		lookAt(enemyQueue.front())

func _on_Area2D_body_exited(body):
	enemyQueue.erase(body)
	
	
