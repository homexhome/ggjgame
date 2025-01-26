extends Node

func pass_last_level(last_level : String):
	await get_tree().create_timer(1.0).timeout
	var i = 5
	while i > 0:
		i -= 1
		Session.show_ad()
		$AudioStreamPlayer2.play()
		
		await get_tree().create_timer(.3).timeout
	$AudioStreamPlayer.play()
	await get_tree().create_timer(.3).timeout
	Loader.load_level(last_level)
		
