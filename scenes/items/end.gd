extends Node

func _ready() -> void:
	Session.get_browser().get_node("BrowserUI").hide()
	Session.get_world().get_node("WorldEnvironment").environment.background_color = Color.BLACK
	show_lore()
	
func show_lore():
	var time = 5.0
	while time > 0:
		time -= get_process_delta_time() 
		$"../human/Control/TextureRect".modulate.a += (get_process_delta_time() / 3)
		await get_tree().process_frame
