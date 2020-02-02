extends KinematicBody2D

export (int) var speed

signal enemyattack

var velocity = Vector2.ZERO
var player_noise = 0
var player_hidden = false
var status = 0
var toogle = -1
onready var first_stop = $"1stPos".position.x

onready var rayf:=$RayCastFront
onready var rayb:=$RayCastBack

onready var playerl = preload("res://assets/MC/MainChar.tscn").instance()

func start(pos):
	position = pos

func _ready():
	pass

func _process(delta):
	if status == 0:
		speed = 30
		patrol()
		if rayf.is_colliding() && player_hidden == false:
			status = 1
		if rayb.is_colliding() && player_noise >= 80 && player_hidden == false:
			status = 1
	elif status == 1:
		speed = 90
		attack()
	elif status == 2:
		velocity.x = 0
		$AnimatedSprite.play("attack")
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
	if area.name == "MainChar":
		status = 2
		emit_signal("enemyattack")

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
