extends Node
class_name Browser

@export var browser_line : LineEdit

func _ready() -> void:
	Session.set_up_browser(self)

func get_browser_line_status():
	var result : bool = false
	if is_instance_valid(browser_line) == false:
		return result
	result = browser_line.has_focus()
	return result

func set_line_text(text : String):
	browser_line.text = text
