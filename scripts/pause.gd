extends Control

onready var startScene = "res://scenes/start.tscn"
export var canPause = true

# Called when the node enters the scene tree for the first time.

func _process(_delta):
	$Popup.rect_size = get_viewport_rect().size
	$Dead.rect_size = get_viewport_rect().size
	if Input.is_action_just_pressed("pause") and canPause:
		get_tree().paused = true
		$Popup.popup()


func _on_Button2_button_up():
	pass


func _on_Button_button_up():
	get_tree().get_root().get_node("Core").switchScene(startScene)
	get_tree().paused = false
	$Popup.hide()
	$Dead.hide()
	canPause = true


func _on_Button2_button_down():
	print("button pressed")
	get_tree().paused = false
	$Popup.hide()
	canPause = true

func deadScreen():
	get_tree().paused = true
	$Dead.popup()
	canPause = false


func _on_restart_button_up():
	get_tree().paused = false
	get_tree().reload_current_scene()
	$Dead.hide()
	canPause = true
