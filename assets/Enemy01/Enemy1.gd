extends KinematicBody2D

export (int) var speed

signal enemyattack

var velocity = Vector2.ZERO
var player_noise = 0
var player_hidden = false
var status = 0
var throwx = 0.0
onready var first_stop = $"1stPos".position.x

onready var rayf:=$RayCastFront
onready var rayb:=$RayCastBack

onready var playerl = load("res://assets/MC/MainChar.tscn").instance()
#onready var canl = load("res://assets/Weapons/Can/Can.tscn").instance()

func start(pos):
	position = pos

func _ready():
	pass

func _process(delta):
	print(status)
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
		#if rayb.is_colliding() && player_hidden == false:
		#	var cont = rayb.get_collider()
		#	if cont.get_name() == "Can":
		#		print(true)
			#status = 1
	elif status == 1:
		speed = 90
		attack()
	elif status == 2:
		velocity.x = 0
		$AnimatedSprite.play("attack")
	elif status == 3:
		print("Now")
		speed = 90
		_find_item()
	elif status == 4:
		velocity.x = 0
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

func _on_Area2D_area_exited(area):
	#speed = 90
	pass
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

func _find_item():
	print("now")
	velocity.x += (throwx - position.x)
	if throwx - position.x < 0:
		$AnimatedSprite.flip_h = true
	elif throwx - position.x > 0.5:
		$AnimatedSprite.flip_h = false
	else:
		status = 4
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

func _on_Can_dissapear(xl):
	status = 3
	#print("now")
	#canl = get_parent().get_node("Can").position
	#status = 3
	throwx = xl
	print(status)
	#print(throwx)
