extends TextureButton


func _ready() -> void:
	pressed.connect(_on_pressed)
	$AudioStreamPlayer.play()
func _on_pressed():
	$"../../../BrowserUI/Tool/AudioStreamPlayer".play()
	show_lore()

func show_lore():
	var time = 14.0
	hide()
	while time > 0:
		time -= get_process_delta_time() 
		$"../TextureRect".modulate.a += (get_process_delta_time() / 3)
		await get_tree().process_frame
	start_game()

func start_game():
	$"../../../BrowserUI".show()
	$"../../../Camera".queue_free()
	Session.get_world().get_node("WorldEnvironment").environment.background_color = Color.WHITE
	await Loader.load_level("http://awell.world/hub")
	$"../../../MainPlayer".play()
	$"../..".queue_free()
