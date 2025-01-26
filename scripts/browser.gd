extends Node
class_name Browser

@export var browser_line : LineEdit
@export var message : Control
@export var important_message : Control

func _ready() -> void:
	Session.set_up_browser(self)
	$BrowserUI.hide()
	Session.get_world().get_node("WorldEnvironment").environment.background_color = Color.BLACK
	

func get_browser_line_status():
	var result : bool = false
	if is_instance_valid(browser_line) == false:
		return result
	result = browser_line.has_focus()
	return result

func set_line_text(text : String):
	browser_line.text = text

func play_message(string : String):
	message.play_message(string)

func play_important_message(string : String, custom_time : float = 0.0):
	important_message.play_message(string, custom_time)
	
	
