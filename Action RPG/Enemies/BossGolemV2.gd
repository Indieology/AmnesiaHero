extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 280
export var MAX_SPEED = 40
export var FRICTION = 450
export var WANDER_TARGET_RANGE = 4
export var MELEE_ATTACK_RANGE = 50
export var experience_pool = 50

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = CHASE

onready var mTimer= $MeleeDetection/MeleeTimer
onready var rTimer= $RangedDetection/RangedTimer
onready var animatedSprite = $Sprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var meleeDetectionZone = $MeleeDetection
onready var rangedDetectionZone = $RangedDetection
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animPlayer = $AnimationPlayer
onready var hitBox = $Hitbox
onready var lazer = $Lazer


func _ready():
	state = IDLE

func _physics_process(delta):
	animPlayer.queue("Idle")
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
				
		WANDER:
			
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
			
		CHASE:
			
			var player = playerDetectionZone.player
			var melee = meleeDetectionZone.player
			var ranged = rangedDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
				if melee != null:
					if mTimer.is_stopped():
						if animatedSprite.flip_h:
							animPlayer.play("MeleeLeft")
						else: animPlayer.play("Melee")
						mTimer.start(1.5)
					animPlayer.queue("Idle")
				if ranged != null:
					if rTimer.is_stopped():
						mTimer.start(2)
						if animatedSprite.flip_h:
							animPlayer.play("LazerCastLeft")
							set_physics_process(false)
							yield(animPlayer,"animation_finished")
							set_physics_process(true)
						else: 
							animPlayer.play("LazerCast")
							set_physics_process(false)
							yield(animPlayer,"animation_finished")
							set_physics_process(true)
						rTimer.start(5)
					animPlayer.queue("Idle")
			else:
				state = IDLE

	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	animatedSprite.flip_h = velocity.x < 0

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	stats.health -= (area.damage + PlayerStats.strength)
	knockback = area.knockback_vector * 130
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(0.4)
	if stats.health <= 0:
		PlayerStats.golem_killed = true
	
	

func _on_Stats_no_health():
	PlayerStats.golem_killed = true
	
	animPlayer.owner.set_physics_process(false)
	velocity = Vector2.ZERO
	animPlayer.play("Death")
	animPlayer.owner.set_physics_process(false)
	PlayerStats.OnKill(experience_pool)
	hitBox.queue_free()
	lazer.queue_free()
	hurtbox.queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	self.set_process(false)
	self.set_physics_process(false)

func _on_Hurtbox_invincibility_started():
	return
	
	
	

func _on_Hurtbox_invincibility_ended():
	return
	
	
