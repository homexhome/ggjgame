extends AudioStreamPlayer

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("forward") and Input.is_key_pressed(KEY_Y):
		play()
