extends Node2D

var enemyScene = load("res://scenes/Enemy.tscn")
var infectedScene = load("res://scenes/infectedPerson.tscn")
var ratScene = load("res://scenes/rat.tscn")
func _ready():
	$EnemySpawnTimer.start(1)
	pause_mode = Node.PAUSE_MODE_INHERIT




func _on_EnemySpawnTimer_timeout():
	var enemyInstance
	var enemyType = randf()
	if enemyType >= 0.5:
		enemyInstance = infectedScene.instance()
	else:
		enemyInstance = ratScene.instance()
	add_child(enemyInstance)
	var spawnLocation = round(randf()*3)
	if spawnLocation == 0:
		spawnLocation =1
	enemyInstance.position = get_node("character/EnemySpawn%s" %spawnLocation).global_position
	
