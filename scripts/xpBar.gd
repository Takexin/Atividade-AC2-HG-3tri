extends ProgressBar

onready var player = get_parent().get_parent().get_node("character")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
func _process(delta):
	if player:
		print()
		self.value = player.xp
		self.max_value = player.xpNeeded

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
