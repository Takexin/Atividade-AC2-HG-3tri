extends KinematicBody2D
onready var player = get_parent().get_parent().get_node("character")
onready var bow = get_parent().get_parent().get_node("character/bow/Sprite")
onready var timer = get_node("Timer")
const speed = 300
export var direction = Vector2(0, 0)

func _ready():
	$Sprite.visible = false
	self.look_at(direction)
	$Area2D.monitoring = false
	global_position = bow.global_position
func _physics_process(delta):
	var collision = move_and_collide(direction * 10, delta)
	if collision:
		if (collision.collider.is_in_group("enemy")):
			$Area2D.monitoring = true
			collision.collider.takeDamage()
			self.queue_free()
func _on_Timer_timeout():
	$Sprite.visible = true


func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()


func _on_Area2D_body_entered(body):
		if body.is_in_group("enemy"):
				pass
