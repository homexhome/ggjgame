extends ColorRect

func _ready() -> void:
	Loader.loading_started.connect(show)
	Loader.loading_ended.connect(hide)
