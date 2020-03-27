extends Light2D

func _process(delta):
	yield(get_tree().create_timer(0), 'timeout')
	if randi()%100+1 >= 100:
		enabled = false;
		yield(get_tree().create_timer(1 * delta), 'timeout')
		enabled = true;