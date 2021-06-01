extends KinematicBody2D

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 120
export var FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK,
	RANGEDATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats
var arrowScene = load("res://Player/Arrow.tscn")

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var arrowTimer = $ArrowTimer
onready var arrowSpawn = $ArrowSpawnTimer
onready var player = $AnimatedSprite
onready var GUI = get_node("../../CanvasLayer")
onready var levelUp = $LevelUp
onready var levelUpLabel = $LevelUp/LevelUpLabel
onready var statTimer = $StatTimer


func _ready():

	randomize()
	stats.connect("no_health", self, "player_death")
	stats.connect("xp_gain", self, "xp_gained")
	stats.connect("level_up",self, "level_up")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector
	arrowTimer.start()
	levelUp.hide()
	GUI.get_node("+1 Health").hide()
	GUI.get_node("+1 Strength").hide()
	GUI.get_node("DeathScreen").hide()
	GUI.get_node("DeathScreen/Label").hide()
	
	
	

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		
		ROLL:
			roll_state()
		
		ATTACK:
			attack_state()
		
		RANGEDATTACK:
			ranged_attack_state()
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationTree.set("parameters/RangedAttack/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		if statTimer.time_left == 0:
			GUI.get_node("+1 Health").hide()
			GUI.get_node("+1 Strength").hide()
	
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	if Input.is_action_pressed("ranged_attack") and arrowTimer.is_stopped() && PlayerStats.has_bow == true:
		state = RANGEDATTACK
		arrowTimer.start()
		var arrow = arrowScene.instance()
		arrowSpawn.start(.4)
		yield(arrowSpawn,"timeout")
		get_parent().add_child(arrow)
		arrow.position = player.global_position
		arrow.position.y = arrow.position.y - 8
		arrow.position.x = arrow.position.x + 5
		if roll_vector.x > .7 and roll_vector.y < .8:
			arrow.velocity.x = 130
		elif roll_vector == Vector2(0,1):
			arrow.velocity.y = 130
			arrow.rotation_degrees = 90
			arrow.position.x = arrow.position.x -5
			arrow.position.y = arrow.position.y -3
		elif roll_vector == Vector2(0,-1):
			arrow.velocity.y = -130
			arrow.rotation_degrees = 270
			arrow.position.x = arrow.position.x -5
		elif roll_vector.x < .7 and roll_vector.y > -.8:
			arrow.velocity.x = -130
			arrow.rotation_degrees = 180
			arrow.position.x = arrow.position.x - 9
		
		

func roll_state():
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")
	
func ranged_attack_state():
	velocity = Vector2.ZERO
	animationState.travel("RangedAttack")
	

func move():
	velocity = move_and_slide(velocity)

func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE

func attack_animation_finished():
	state = MOVE

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.9)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)
	
func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")

func xp_gained():
	var leveled = PlayerStats.leveled
	GUI.UpdateExperienceBar(leveled)

func level_up():
	levelUp.frame = 0
	GUI.get_node("+1 Health").show()
	GUI.get_node("+1 Strength").show()
	levelUpLabel.show()
	statTimer.start(5)
	levelUp.show()
	levelUp.play()
	yield(levelUp, "animation_finished")
	levelUp.hide()
	
	levelUpLabel.hide()
	PlayerStats.experience_required = PlayerStats.experience_required * 2
	GUI.SetExperienceBar()
	
func player_death():
	queue_free()
