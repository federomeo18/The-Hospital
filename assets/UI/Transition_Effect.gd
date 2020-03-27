extends ColorRect

var cutoff = 0.0

func _process(_delta):
	material.set("shader_param/cutoff", cutoff)