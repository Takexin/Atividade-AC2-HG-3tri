extends ProgressBar

onready var player = get_parent().get_node("character")
func _ready():
	CanvasLayer.position
func process():
	if player:
		self.value = player.health

