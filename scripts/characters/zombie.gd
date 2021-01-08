extends KinematicBody2D

var velocity: Vector2 = Vector2(0,0)
const UP: Vector2 = Vector2(0,-1)
export var speed: int = 300
export var direction: int = -1
var gravity: int = 1200

signal kill_player

func _ready():
	
	$Body.scale.x = direction

func _physics_process(delta):
	
	if self.is_on_wall():
		_change_dir()
	
	velocity.y += gravity * delta
	velocity.x = lerp(velocity.x, speed * direction, 0.2)
	velocity = move_and_slide(velocity, UP)
	$Body/AnimatedSprite.play("zombie_running")


func _change_dir():
	
	direction *= -1
	$Body.scale.x = direction


func _on_KillArea_body_entered(body):
	if body.is_in_group("player_attacks"):
		self.queue_free()
	pass 


func _on_AttackArea_body_entered(body):
	if body.is_in_group("player_attacks"):
		emit_signal("kill_player")
	pass 
