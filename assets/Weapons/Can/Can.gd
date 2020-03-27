extends RigidBody2D

func _ready():
	apply_impulse(Vector2(),Vector2(100,-100).rotated(rotation))
	
func _process(_delta):
	if position.y >= 590:
		queue_free()