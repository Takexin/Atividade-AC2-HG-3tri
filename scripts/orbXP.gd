extends KinematicBody2D
#remember: low - 3, medium - 6, high: 12
onready var player = get_parent().get_node("character")
export var xpAmmount = 0
var move = false

func _ready():
	pass
func _physics_process(delta):
	if player and !player.is_connected("foundOrb", self, "onOrbFound"):
		player.connect("foundOrb", self, "onOrbFound")
		print("connected")
	if move:
		var direction = (player.position - position).normalized()
		var collision = move_and_collide(direction * 10, delta)
		if collision:
			queue_free()

func onOrbFound():
	print("found orb AAAA")
	move = true
