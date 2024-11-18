extends Popup

var axe = preload("res://scenes/weakpons/Axe.tscn")
var bow = preload("res://scenes/weakpons/bow.tscn")
var femur = preload("res://scenes/weakpons/Femur.tscn")
var mace = preload("res://scenes/weakpons/mace.tscn")
var potion = preload("res://scenes/weakpons/potionWeapon.tscn")
var sword = preload("res://scenes/weakpons/sword.tscn")
var weapons = [axe, bow, femur, mace, potion, sword]
var weaponsName = ["axe", "bow", "femur", "mace", "potion", "sword"]

#sprites
var axeSprite = preload("res://assets/images/weaponDisplay/machado atack 1.png")
var femurSprite = preload("res://assets/images/weaponDisplay/bone2.png")
var maceSprite = preload("res://assets/images/weaponDisplay/mace1.png")
var potionSprite = preload("res://assets/images/poção.png")
var swordSprite = preload("res://assets/images/weaponDisplay/a1.png")
var bowSprite = preload("res://assets/images/bow.png")

#player node
onready var player = get_tree().get_root().get_node("Core/main/character")
var firstTime = true
func _process(_delta): # for testing, remove later
	rect_size = get_viewport_rect().size
	#rect_position = get_viewport_rect().size/2
func _ready():
	randomize()
	runRandom()
var randomNums = []
var numChecker = []
func runRandom():
	popup_exclusive = true
	if !firstTime:
		get_tree().get_root().get_node("Core/main/AudioStreamPlayer").pause_mode = Node.PAUSE_MODE_PROCESS
		get_tree().get_root().get_node("Core/main/AudioStreamPlayer").volume_db = -10
	self.popup()
	$AudioStreamPlayer.play()
	get_tree().paused = true
	get_parent().get_node(".").canPause = false #parent node (control2 on main)
	var i =0
	while i < 3:
		var hasSeen = false
		var num = int(rand_range(0,6)+1)
		for number in randomNums:
			if num == number:
				hasSeen = true
		if !hasSeen:
			randomNums.push_back(num)
			i+=1
	i = 0
	for child in get_children():
		if child.is_in_group("button"):
			var random = randomNums[i]
			i+=1
			match random:
				1:
					child.text = "Axe"
					child.get_node("Sprite").texture = (axeSprite)
				2:
					child.text = "bow"
					child.get_node("Sprite").texture = bowSprite
				3:
					child.text = "femur"
					child.get_node("Sprite").texture = femurSprite
				4:
					child.text = "mace"
					child.get_node("Sprite").texture = maceSprite 
				5:
					child.text = "potion"
					child.get_node("Sprite").texture = potionSprite
				6:
					child.text = "sword"
					child.get_node("Sprite").texture = swordSprite
			
func closePop():
	popup_exclusive = true
	get_tree().get_root().get_node("Core/main/AudioStreamPlayer").volume_db = -10
	firstTime = false
	randomNums = []
	numChecker = []
	get_parent().canPause = true
	get_tree().paused = false
	hide()

	#player.addWeapon(weapons[randomNums[0]-1])
	#player.addWeapon("res://scenes/weakpons/Axe.tscn")
func _on_Button2_button_up():
	player.addWeapon(weapons[randomNums[0]-1], weaponsName[randomNums[0]-1])
	$AudioStreamPlayer2.play(0.5)
	yield($AudioStreamPlayer2, "finished")
	closePop()
	


func _on_Button3_button_up():
	$AudioStreamPlayer2.play(0.5)
	yield($AudioStreamPlayer2, "finished")
	player.addWeapon(weapons[randomNums[1]-1], weaponsName[randomNums[1]-1])
	closePop()


func _on_Button4_button_up():
	$AudioStreamPlayer2.play(0.5)
	yield($AudioStreamPlayer2, "finished")
	player.addWeapon(weapons[randomNums[2]-1], weaponsName[randomNums[2]-1])
	closePop()

