extends Node3D

@export var array_of_text : Array[String]

func _ready() -> void:
	$Area3D.body_entered.connect(_on_body_enter)
	
func _on_body_enter(body):
	while Loader.loading:
		await get_tree().process_frame
		
	if body is not Player: return
	for string in array_of_text:
		$AudioStreamPlayer3D.pitch_scale = randf_range(0.9,1.1)
		$AudioStreamPlayer3D.play()
		Session.get_browser().play_important_message(string)
		await get_tree().create_timer(3.0).timeout
	queue_free()
