extends KinematicBody2D
onready var player = get_parent().get_parent().get_node("character")
onready var bow = get_parent().get_parent().get_node("character/bow/Sprite")
onready var timer = get_node("Timer")
const speed = 300
export var direction = Vector2(0,0)
signal projectileDamage
func _ready():
	$Sprite.visible = false
	self.look_at(direction)
	global_position = bow.global_position
func _physics_process(delta):
	var collision = move_and_collide(direction * 10, delta)
	var enemyName = "Enemy"
	if collision:
		if !(collision.collider.get_name().substr(0, enemyName.length()) == enemyName):
			self.queue_free()
func _on_Timer_timeout():
	$Sprite.visible = true


func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()
