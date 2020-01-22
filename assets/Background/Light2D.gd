extends Light2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	yield(get_tree().create_timer(0), 'timeout')
	if randi()%100+1 >= 100:
		enabled = false;
		yield(get_tree().create_timer(1 * delta), 'timeout')
		enabled = true;
#	pass
