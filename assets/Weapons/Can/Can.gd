extends RigidBody2D

#export (PackedScene) var enemy

signal dissapear

onready var enemy = preload("res://assets/Enemy01/Enemy1.tscn").instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	#connect("dissapear", enemy,"_on_Can_dissapear")
	apply_impulse(Vector2(),Vector2(80,-100).rotated(rotation))
	
func _process(delta):
	if position.y >= 590 && position.y <= 600:
		enemy._on_Can_dissapear(position.x)
		queue_free()