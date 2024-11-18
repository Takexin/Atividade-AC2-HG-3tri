extends Node2D
onready var player = get_parent().get_node(".")
var projectileScene = preload("res://scenes/weakpons/potion.tscn")

export var weaponCooldown: float = 0
export var isLookingAt = false
var lookAtPos = Vector2(0, 0)
var lookAtNode = Node2D
var canShoot = true
var enemyQueue = []
func _ready():
	pass


func shoot(body: Node):
	if canShoot and body:
		$AudioStreamPlayer2D.play(0.5)
		var projectileInstance = projectileScene.instance()
		projectileInstance.set_name("projectile")
		projectileInstance.direction = (body.position - player.position).normalized()
		get_tree().get_root().get_node("Core/main/projectileContainer").add_child(projectileInstance)
		canShoot = false
		$shootCooldown.start(weaponCooldown)
	else:
		#isLookingAt = false
		pass
func _on_shootCooldown_timeout():
	canShoot = true
	lookAt(lookAtNode)

func _process(_delta):
	$anchor.look_at(lookAtPos)
func lookAt(body: Node2D):
	if body:
		isLookingAt = true
		lookAtPos = body.position
		lookAtNode = body
		shoot(body)
	else:
		isLookingAt = false
func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		lookAt(body)

func _on_Area2D_body_exited(body):
	pass
