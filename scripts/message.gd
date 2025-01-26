extends Control
@export var label : Label
@export var animation_player : AnimationPlayer
@export var timer : Timer 
@export var important_message : Control
@export var timer_time : float = 3.0
var active : bool = false

func play_message(string : String, custom_time : float = 0.0):
	if important_message!= null and important_message.active: return
	active = true
	if timer.is_stopped() == false:
		timer.stop()
	if custom_time != 0:
		timer.wait_time = custom_time
	else:
		timer.wait_time = timer_time
	label.text = string
	animation_player.play("play_message")
	timer.start()
	
func stop_message():
	active = false
	hide()
