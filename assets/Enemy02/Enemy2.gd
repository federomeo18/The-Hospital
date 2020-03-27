extends KinematicBody2D

export (int) var speed
#export (PackedScene) var can

signal enemyattack

var velocity = Vector2.ZERO
var player_noise = 0
var player_hidden = false
var status = 0
#var throwx = 0.0
onready var first_stop = $"1stPos".position.x
#var canl = null

onready var rayf:=$RayCastFront
onready var rayb:=$RayCastBack

onready var playerl = load("res://assets/MC/MainChar.tscn").instance()
#onready var canl = load("res://assets/Weapons/Can/Can.tscn").instance()

func start(pos):
	position = pos

func _ready():
	pass

func _process(delta):
	#print(status)
	if status == 0:
		speed = 30
		patrol()
		if rayf.is_colliding() && player_hidden == false:
			var cont = rayf.get_collider()
			if cont.get_name() == "MainChar":
				status = 1
		if rayb.is_colliding() && player_noise >= 80 && player_hidden == false:
			var cont = rayb.get_collider()
			if cont.get_name() == "MainChar":
				status = 1
		if rayb.is_colliding():# && player_hidden == false:
			var cont = rayb.get_collider()
			if cont.get_name() == "Can"  || cont.get_name() == "Brick":
				status = 3
		if rayf.is_colliding():# && player_hidden == false:
			var cont = rayf.get_collider()
			if cont.get_name() == "Can"  || cont.get_name() == "Brick":
				status = 3
	elif status == 1:
		speed = 90
		attack()
	elif status == 2:
		velocity.x = 0
		$AnimatedSprite.play("attack")
	elif status == 3:
		speed = 90
		if get_tree().get_current_scene().get_node("Can"):
			_find_item1()
			yield(get_tree().create_timer(1), 'timeout')
			status = 4
		if get_tree().get_current_scene().get_node("Brick"):
			_find_item2()
			yield(get_tree().create_timer(1), 'timeout')
			status = 4
	elif status == 4:
		velocity.x = 0
		yield(get_tree().create_timer(1), 'timeout')
		status = 0
	_vision(delta)

func _physics_process(delta):
	position += velocity * delta

func _vision(test):
	test = null
	if velocity.x <= 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
	if $AnimatedSprite.flip_h == true:
		$RayCastFront.cast_to = Vector2(-60,0)
		$RayCastBack.cast_to = Vector2(60,0)
	else:
		$RayCastFront.cast_to = Vector2(60,0)
		$RayCastBack.cast_to = Vector2(-60,0)

func attack():
	playerl = get_parent().get_node("MainChar").position
	velocity.x += (playerl.x - position.x)
	if playerl.x - position.x < 0:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

func _find_item1():
	var item = get_tree().get_current_scene().get_node("Can").position.x
	velocity.x += (item - position.x)
	if item - position.x < 0:
		$AnimatedSprite.flip_h = true
	elif item - position.x > 0.5:
		$AnimatedSprite.flip_h = false
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
func _find_item2():
	var item = get_tree().get_current_scene().get_node("Brick").position.x
	velocity.x += (item - position.x)
	if item - position.x < 0:
		$AnimatedSprite.flip_h = true
	elif item - position.x > 0.5:
		$AnimatedSprite.flip_h = false
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

func patrol():
	velocity.x += (first_stop - position.x)
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

func _on_Area2D_area_entered(area):
	if area.name == "MainChar" && player_hidden == false:
		status = 2
		emit_signal("enemyattack")
	if area.name == "MainChar" && player_hidden == true:
		status = 0

#func _on_Area2D_area_exited(area):
	#speed = 90
#	pass
	#is_entered = area
	#is_entered = null
	#velocity.x = 0

func _on_MainChar_playerattack():
	if rayb.is_colliding():
		queue_free()

func _on_MainChar_noiselevelchanged(noiselevel):
	player_noise = noiselevel

func _on_MainChar_playerhidden(is_hidden):
	player_hidden = is_hidden