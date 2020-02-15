extends RigidBody2D

#export (PackedScene) var enemy

#signal dissapear(x)

onready var connector = preload("res://assets/Other/Connector.tscn").instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	#connect("dissapear", connector,"_get_values")
	apply_impulse(Vector2(),Vector2(80,-100).rotated(rotation))
	
func _process(delta):
	if position.y >= 590 && position.y <= 600:
		#emit_signal("dissapear",position.x)
		connector._get_values(position.x)
		queue_free()