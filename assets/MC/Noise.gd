extends Area2D

func _ready():
	#visible = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Sprite.scale += Vector2(5.0 * delta, 5.0 * delta)
	if $Sprite.scale.x >= 3:
		visible = false