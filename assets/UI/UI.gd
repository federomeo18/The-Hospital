extends CanvasLayer

func _on_MainChar_noiselevelchanged(noiselevel):
	if($SoundBar/TextureProgress.value <= noiselevel):
		$SoundBar/TextureProgress.value += 1
	elif($SoundBar/TextureProgress.value >= noiselevel):
		$SoundBar/TextureProgress.value -= 1

func _process(_delta):
	if Scene_handler.cut_scene == true:
		$Panel.visible = true
	else:
		$Panel.visible = false
	if Scene_handler.keys[0] == true:
		$RedKey_UI.visible = true
	else:
		$RedKey_UI.visible = false
	if Scene_handler.weapon[5] == true:
		$Can_UI.visible = true
	else:
		$Can_UI.visible = false
	if Scene_handler.weapon[1] == true:
		$Scalpel_UI.visible = true
	else:
		$Scalpel_UI.visible = false