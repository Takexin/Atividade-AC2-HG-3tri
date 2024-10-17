extends KinematicBody2D
onready var player = get_parent().get_node("character")
const speed = 300

func _ready():
	global_position = player.position + Vector2(10,10)
func _physics_process(delta):
	var direction = (get_viewport(). get_mouse_position()).normalized()
	var collision = move_and_collide(direction * speed, delta)
	if collision:
		self.free()
