extends LineEdit

var loading : bool = false

func _ready() -> void:
	Loader.loading_started.connect(block_input)
	Loader.loading_ended.connect(unlock_input)
	text_submitted.connect(handle_website_input)

func block_input():
	editable = false

func unlock_input():
	editable = true

func handle_website_input(string : String):
	if loading: return
	loading = true
	var result = await Loader.load_level(string)
	release_focus()
	loading = false
