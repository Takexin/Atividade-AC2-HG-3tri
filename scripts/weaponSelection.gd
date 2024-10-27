extends Popup

# var axe = load("res://scenes/weakpons/Axe.tscn")
# var bow = load("res://scenes/weakpons/bow.tscn")
# var femur = load("res://scenes/weakpons/Femur.tscn")
# var mace = load("res://scenes/weakpons/mace.tscn")
# var potion = load("res://scenes/weakpons/potion.tscn")
# var sword = load("res://scenes/weakpons/sword.tscn")
# var weapons = [axe, bow, femur, mace, potion, sword]

#sprites
var axeSprite = preload("res://assets/images/weaponDisplay/machado atack 1.png")
var femurSprite = preload("res://assets/images/weaponDisplay/bone2.png")
var maceSprite = preload("res://assets/images/weaponDisplay/mace1.png")
var potionSprite = preload("res://assets/images/poção.png")
var swordSprite = preload("res://assets/images/weaponDisplay/a1.png")
var bowSprite = preload("res://assets/images/bow.png")
# Called when the node enters the scene tree for the first time.

func _process(_delta):
	if Input.is_action_just_pressed("mouseLeft"):
		get_tree().reload_current_scene()
func _ready():
	randomize()
	self.popup()
	runRandom()
var randomNums = []
var numChecker = []
func runRandom():
	var i =0
	while i < 3:
		var hasSeen = false
		var num = int(rand_range(1,6))
		for number in randomNums:
			if num == number:
				hasSeen = true
		if !hasSeen:
			randomNums.push_back(num)
			i+=1
	i = 0
	for child in get_children():
		if child.is_in_group("button"):
			print(child)
			print(i)
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
			
