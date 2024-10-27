extends Node2D

var mainScene = load("res://scenes/main.tscn")

func _ready():
	$AnimationPlayer.play("start")
	$AudioStreamPlayer2D.play(22.4)
	$Light2D.energy = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$CanvasLayer/Control.rect_position = get_viewport_rect().size/2


func _on_Button_button_up():
	get_tree().change_scene_to(mainScene)


func _on_Button3_button_up():
	get_tree().quit()
