extends KinematicBody2D
onready var player = get_parent().get_node("character")
onready var timer = get_node("Timer")
const speed = 300
var direction
func _ready():
	$Sprite.visible = false
	var enemy = get_parent().get_node("Enemy")
	if enemy:
		direction = (enemy.position - player.position).normalized()
		self.look_at(direction)
	# direction = (get_viewport().get_mouse_position() - player.position ).normalized()
	
	global_position = player.position
func _physics_process(delta):
	
	var collision = move_and_collide(direction * 10, delta)
	if collision:
		self.queue_free()
func _on_Timer_timeout():
	$Sprite.visible = true


func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()
