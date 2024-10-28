extends KinematicBody2D
#remember: low - 3, medium - 6, high: 12
onready var player = get_parent().get_node("character")
export var xpAmmount = 3
var move = false

func _ready():
	pass
func _physics_process(delta):
	if player and !player.is_connected("foundOrb", self, "onOrbFound"):
		player.connect("foundOrb", self, "onOrbFound")
	if move:
		var direction = (player.position - position).normalized()
		var collision = move_and_collide(direction * 10, delta)
		if collision:
			if !$AudioStreamPlayer2D.is_playing():
				$AudioStreamPlayer2D.play()
				hide()
				$CollisionShape2D.queue_free()
			if $AudioStreamPlayer2D.get_playback_position() >= 0.3:
				player.xp += xpAmmount
				queue_free()

func onOrbFound():
	move = true


