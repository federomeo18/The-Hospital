extends CanvasLayer

func _on_MainChar_noiselevelchanged(noiselevel):
	if($SoundBar/TextureProgress.value <= noiselevel):
		$SoundBar/TextureProgress.value += 1
	elif($SoundBar/TextureProgress.value >= noiselevel):
		$SoundBar/TextureProgress.value -= 1

func _ready():
	pass
	#$tween.interpolate_property($"Transition_Effect", "cutoff", 0.0,1.0,1.0,Tween.TRANS_QUINT,Tween.EASE_IN_OUT)
	#$tween.start()
	#yield(get_tree().create_timer(2), 'timeout')
	#$tween.interpolate_property($"Transition_Effect", "cutoff", 1.0,-1.0,1.0,Tween.TRANS_QUINT,Tween.EASE_IN_OUT)
	#$tween.start()

func _process(_delta):
	if Scene_handler.cut_scene == true:
		$Panel.visible = true
	else:
		$Panel.visible = false