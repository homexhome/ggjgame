extends Control

var all_spam : Array

func _ready() -> void:
	for child in get_children():
		all_spam.append(child)
		child.hide()
	Session.set_current_spam(self)

func show_random_ad():
	var array : Array
	for ad in all_spam:
		if ad.visible == false:
			array.append(ad)

	if array.size() > 0:
		array.pick_random().show()

func hide_ads():
	for ad in all_spam:
		ad.hide()
