extends Label


func _ready():
	if Scene_handler.cut_scene_n == 0:
		text = "Where am I? I... I... can't remember how I got here.\nI'm not hurt so, whose blood is this?\n\n\nPress action to continue..."
	if Scene_handler.cut_scene_n == 2:
			text = "What is that thing? It doesn't seem to notice me. I need a way to distract it\nMaybe I can throw the can I just picked up and run to that hallway\n\n\nPress the action button to throw"

func _input(event):
	if event.is_action_pressed("Action") && Scene_handler.cut_scene == true:
		Scene_handler.cut_scene_n = Scene_handler.cut_scene_n + 1
		if Scene_handler.cut_scene_n == 1:
			text = "Oh my god! Is that... Is that a dead body?\nHis body is all torn. What is going on in here?"