extends Node2D

var enemyScene = load("res://scenes/Enemy.tscn")
func _ready():
	$EnemySpawnTimer.start(1)
func _process(delta):
		pass



func _on_EnemySpawnTimer_timeout():
	var enemyInstance = enemyScene.instance()
	enemyInstance.set_name("Enemy")
	add_child(enemyInstance, true)
	var spawnLocation = round(randf()*3)
	if spawnLocation == 0:
		spawnLocation =1
	enemyInstance.position = get_node("character/EnemySpawn%s" %spawnLocation).global_position
	
