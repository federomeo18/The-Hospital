extends CanvasLayer

func _on_MainChar_noiselevelchanged(noiselevel):
	if($SoundBar/TextureProgress.value <= noiselevel):
		$SoundBar/TextureProgress.value += 1
	elif($SoundBar/TextureProgress.value >= noiselevel):
		$SoundBar/TextureProgress.value -= 1
