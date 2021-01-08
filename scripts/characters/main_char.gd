extends KinematicBody2D

var velocity: Vector2 = Vector2(0,0)
const UP = Vector2(0,-1)
onready var body: Node2D = $Body
var gravity: int = 1200
export var speed: int = 500
const SLOPE_STOP = 64
export var jump_velocity = -720
var is_grounded: bool

onready var ground_check: Node2D = $GroundCheck #check for ground using raycasts

func _physics_process(delta):
	_get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, UP, SLOPE_STOP) 
	is_grounded = _check_is_grounded()
	_assign_animation()
	pass
	
func _input(event):
		
	if event.is_action_pressed("jump") && is_grounded:
		velocity.y = jump_velocity
	pass
	
func _get_input():
	var dir = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	velocity.x = lerp(velocity.x, speed * dir, _get_h_weight())
	if dir != 0:
		body.scale.x = dir

func _check_is_grounded() -> bool:
	for raycast in ground_check.get_children():
		if raycast.is_colliding():
			return true
			
	return false
	pass

func _get_h_weight() -> float:
	return 0.2 if is_grounded else 0.1
	pass
	
func _assign_animation():
	var anim = "player_idle"
	if !is_grounded:
		anim = "player_jumping"
	elif velocity.x != 0:
		anim = "player_running"
	if body.get_child(0).animation != anim:
		print($Body/AnimatedSprite.animation)
		body.get_child(0).play(anim)


func _on_zombie_kill_player():
	self.queue_free()
	pass 
