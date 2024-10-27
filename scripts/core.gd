extends Node2D




func _ready():
	pass 

func switchScene(sceneName : String):
	#remove all nodes from main
	$main.queue_free()
	var scene = load(sceneName)
	yield(get_tree().create_timer(0.1), "timeout")
	add_child(scene.instance())

