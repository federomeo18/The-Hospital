extends RigidBody2D

signal dissapear

# Called when the node enters the scene tree for the first time.
func _ready():
	apply_impulse(Vector2(),Vector2(80,-100).rotated(rotation))
	
func _process(delta):
	position += Vector2(10,-10)
	if position.y >= 630:
		queue_free()