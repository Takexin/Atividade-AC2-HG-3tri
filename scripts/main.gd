extends Node2D

var enemyScene = load("res://scenes/Enemy.tscn")
var infectedScene = load("res://scenes/infectedPerson.tscn")
var ratScene = load("res://scenes/rat.tscn")
var startScene = load("res://scenes/start.tscn")
var time = 0.0
var timeSpawn = 5
var canDecrease : bool = true
export var enemyCounter = 0
var enemyCap = 24
var difficulty = 0.0
func _ready():
	var player = $character
	player.connect("playerLevel", self, "onPlayerLevel")
	$EnemySpawnTimer.start()
	pause_mode = Node.PAUSE_MODE_INHERIT
	randomize()

func onPlayerLevel(level):
	difficulty += 0.2
	enemyCap += 10
func _process(delta):
	$EnemySpawnTimer.wait_time = timeSpawn
	time += delta
	get_tree().get_root().get_node("Core/CanvasLayer/Control2/Label").text = str(time).pad_decimals(2)
	get_tree().get_root().get_node("Core/CanvasLayer/Control2/Label").rect_position.x = get_viewport_rect().size.x/2
	timerDecrease()
func timerDecrease():
	if canDecrease:
		canDecrease = false
		yield(get_tree().create_timer(2), "timeout")
		if timeSpawn >= 0.2:
			timeSpawn= abs(timeSpawn - 0.1)
		canDecrease = true
func _on_EnemySpawnTimer_timeout():
	print(enemyCounter)
	if enemyCounter < enemyCap:
		enemyCounter += 1
		var enemyInstance
		var enemyType = randf()
		if enemyType >= 0.5:
			enemyInstance = infectedScene.instance()
		else:
			enemyInstance = ratScene.instance()
		enemyInstance.health = enemyInstance.health + enemyInstance.health*difficulty
		add_child(enemyInstance)
		var spawnLocation = round(randf()*3)+1
		if spawnLocation == 0:
			spawnLocation =1
		enemyInstance.position = get_node("character/EnemySpawn%s" %spawnLocation).global_position
		


