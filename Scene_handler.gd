extends Node

var scenes = ['res://assets/Scenes/Scene00.tscn', 'res://assets/Scenes/Scene01.tscn','res://assets/Scenes/Scene02.tscn']

var current_level = 0

var start_screen
var end_screen

var cut_scene = true
var cut_scene_n = 0
#var level_change = true

var weapon = [true, false, false, false, false, false]
#0 = no weapon, 1 = scalpel, 2 = pipe, 3 = needle, 4 = brick, 5 = can

func new_game():
	current_level = -1
	next_level()

func game_over():
	print("Game Over")

func next_level ():
	#current_level += 1
	if current_level >= Scene_handler.scenes.size():
		game_over()
	else:
		get_tree().change_scene(scenes[current_level])