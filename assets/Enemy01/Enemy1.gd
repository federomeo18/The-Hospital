extends KinematicBody2D

export (int) var speed

signal enemyattack

var velocity = Vector2.ZERO
#var player
#var is_entered = null
#var can_move = true
#var can_attack = true

onready var rayf:=$RayCastFront
#onready var rayb:=$RayCastBack

onready var playerl = preload("res://assets/MC/MainChar.tscn").instance()

func start(pos):
	position = pos

func _ready():
	pass
	#$AnimatedSprite.flip_h = true
#func get_input():
#	if Input.is_action_pressed("ui_left"):
#		$AnimatedSprite.flip_h = true
#	if Input.is_action_pressed("ui_right"):
#		$AnimatedSprite.flip_h = false
#func _ready():
	#player.connect("hurt", self, "on_hurt")
	#player.connect("playerattack", self, "on_hurt")
	
func _process(delta):
	#get_input()
	_vision(delta)
	if rayf.is_colliding():
		attack()

func _physics_process(delta):
	position += velocity * delta
	

func _vision(test):
	test = null
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

func _on_Area2D_area_entered(area):
	speed = 0
	emit_signal("enemyattack")
	#velocity.x = 0
	#pass
	#player = get_parent().get_node("MainChar").position
	#is_entered = area
	#velocity.x += (player.x - position.x)
	#if player.x - position.x < 0:
	#	$AnimatedSprite.flip_h = true
	#else:
	#	$AnimatedSprite.flip_h = false
	#if velocity.length() > 0:
	#	velocity = velocity.normalized() * speed

func _on_Area2D_area_exited(area):
	speed = 90
	#pass
	#is_entered = area
	#is_entered = null
	#velocity.x = 0

func _on_MainChar_playerattack():
	queue_free()
