extends Control




# Called when the node enters the scene tree for the first time.

func _process(delta):
	$Popup.rect_size = get_viewport_rect().size
	print($Popup.rect_size)
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true
		$Popup.popup()


func _on_Button2_button_up():
	pass


func _on_Button_button_up():
	pass # Replace with function body.


func _on_Button2_button_down():
	print("button pressed")
	get_tree().paused = false
	$Popup.hide()

