extends Node

func pass_last_level(last_level : String):
	await get_tree().create_timer(1.0).timeout
	var i = 14
	while i > 0:
		i -= 1
		Session.show_ad()
		await get_tree().create_timer(0.4).timeout
	$AudioStreamPlayer.play()
	await get_tree().create_timer(1).timeout
	$AudioStreamPlayer2.play()
	await get_tree().create_timer(0.5).timeout
	Loader.load_level(last_level)
		
