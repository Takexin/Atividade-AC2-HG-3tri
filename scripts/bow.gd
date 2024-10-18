extends KinematicBody2D
onready var player = get_parent().get_node("character")
const speed = 300
var direction
func _ready():
	direction = (get_viewport().get_mouse_position() - position).normalized()
	
	global_position = get_viewport().get_mouse_position()
func _physics_process(delta):
	
	var collision = move_and_collide(direction * 1, delta)
	if collision:
		self.free()
