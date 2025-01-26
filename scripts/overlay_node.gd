extends Node
@export var overlay_material : StandardMaterial3D
@onready var timer = $Timer

func _ready() -> void:
		overlay_material = preload("res://resources/info_hover.tres")
		Session.info_signal.connect(_on_info_emitted)
		timer.timeout.connect(_on_timeout)


func _on_info_emitted():
		get_parent().material_override = overlay_material
		if timer.is_stopped() == false:
			timer.stop()
		timer.start()
		
func _on_timeout():
	if get_parent().material_override == overlay_material:
		get_parent().material_override = null
