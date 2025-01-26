extends Node3D

@export var event : int = 0
@export var text_to_say : String
func _ready() -> void:
	$Area3D.body_entered.connect(_on_body_enter)
	
func _on_body_enter(body):
	if body is not Player: return
	$AudioStreamPlayer3D.play()
	Session.get_browser().play_important_message(text_to_say)
	await $AudioStreamPlayer3D.finished
	Session.add_event(event)
	queue_free()
