extends KinematicBody2D

export var health = 10
export var max_health = 10
export var xp = 0
export var xpNeeded = 10
export var level = 1
signal playerLevel(level)
var canDamaged = true
const SPEED = 15000
onready var timer = get_node("Timer")
onready var timer2 = get_node("Timer2")
onready var sprite = get_node("Sprite")
onready var weaponSelect = get_tree().get_root().get_node("Core/CanvasLayer/Control2/weaponSelection")
signal foundOrb


var enemyName = "Enemy"
 
#Weapon instances
# var weaponBow = load("res://scenes/weakpons/bow.tscn")
# var weaponAxe = load("res://scenes/weakpons/Axe.tscn")
# var femur = preload("res://scenes/weakpons/Femur.tscn")
# var mace = preload("res://scenes/weakpons/mace.tscn")
# var potion = preload("res://scenes/weakpons/potionWeapon.tscn")
# var sword = preload("res://scenes/weakpons/sword.tscn")

# var weapons = [weaponBow, weaponAxe]


func _ready():
	$CanvasLayer/healthBar.max_value = max_health
	$CanvasLayer/healthBar.value = health
	$CanvasLayer/xpBar.max_value = xpNeeded
	$Camera2D.zoom = Vector2(0.9,0.9)
	randomize()
	

func levelUp():
	level += 1
	xp = 0
	xpNeeded += xpNeeded * 0.75 # 75% increase each level
	$CanvasLayer/xpBar.value = xp
	$CanvasLayer/xpBar.max_value = xpNeeded
	$CanvasLayer/Label.text = String(level)
	weaponSelect.runRandom()
	emit_signal("playerLevel", level)

var canPlay = true
func _physics_process(delta):
	var velocity = Vector2()
	if (Input.is_action_pressed("keyUp")):
		velocity.y = -1 * SPEED
	if (Input.is_action_pressed("keyDown")):
		velocity.y = 1 * SPEED
	if (Input.is_action_pressed("keyLeft")):
		velocity.x = -SPEED
	if (Input.is_action_pressed("keyRight")):
		velocity.x = SPEED
	move_and_slide(velocity * delta)
	if (velocity.x > 0):
		$AnimationPlayer.play("walk")
		$Sprite.scale.x = 2.5
	elif (velocity.x < 0):
		$AnimationPlayer.play("walk")
		$Sprite.scale.x = -2.5
	if (velocity.y != 0 and velocity.x == 0):
		$AnimationPlayer.play("walk")
	elif (velocity == Vector2(0, 0)):
		$AnimationPlayer.stop()
		$Sprite.frame = 1
	# if (Input.is_action_pressed("restart")):
	# 	get_tree().reload_current_scene()
	
	if velocity != Vector2.ZERO and canPlay:
		$WalkSound.play()
		canPlay = false
		$walkTimer.start(0.5)
	elif velocity == Vector2(0,0):
		$WalkSound.playing = false
		
var blincControl = 0
var numLoops = 2

func _on_Enemy_damage():
	if canDamaged:
		var sound = int(rand_range(1,3))
		match sound:
			1:$damage.play()
			2:$damage2.play()
			3:$damage3.play()
		health -= 1
		canDamaged = false
		$damageTimer.start()
		print("damage taken")
		$CanvasLayer/healthBar.value = health
		blinc()
		if (health == 0):
			get_tree().get_root().get_node("Core/CanvasLayer/Control2").deadScreen()

func _on_damageTimer_timeout():
	canDamaged = true
	
func shoot():
	$Timer2.start(1)
func blinc():
	sprite.modulate = Color(255, 255, 255)
	timer.start(0.1)
func _on_Timer_timeout():
	sprite.modulate = Color(1, 1, 1)
func moveOrb(body):
	var direction = (position - body.position).normalized() * 10
	body.position -= direction

var weapons = []
var weaponsType = []
var weaponsNum = []
func addWeapon(weaponScene, type):
	var weapon = weaponScene.instance()
	var foundIndex = weaponsType.find(type)
	if foundIndex == -1: 
		weapons.push_back(weapon)
		weaponsType.push_back(type)
		weaponsNum.push_back(1)
		print(weapon)
		weapon.global_position = global_position
		add_child(weapon)
		weapon.global_position = global_position
	else:
		weaponsNum[foundIndex] += 1
		weapons[foundIndex].weaponCooldown -= 1
		if weapons[foundIndex].get_node("AnimationPlayer"):
			weapons[foundIndex].get_node("AnimationPlayer").playback_speed += 0.2
		print("weapon cooldown %s" % weapons[foundIndex].weaponCooldown)
func _on_Area2D_body_entered(body):
	if body.is_in_group("xp"):
		emit_signal("foundOrb")
		xp += body.xpAmmount
		health += body.healthAmmount
		$CanvasLayer/healthBar.value = health
		$CanvasLayer/xpBar.value = xp
		if health > max_health:
			health = max_health
		if xp >= xpNeeded:
			levelUp()



func _on_walkTimer_timeout():
	canPlay = true
		
