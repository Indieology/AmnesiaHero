extends Node



export(int) var max_health = 1 setget set_max_health
var health = max_health setget set_health
export var strength = 0
export var speed = 1

var level = 1
var experience = 0
var experience_required = 143
var leveled = false
var slimes_killed = 0
var skeletons_killed = 0
var golem_killed = false
var coins = 0
var has_bow = false


signal no_health
signal health_changed(value)
signal max_health_changed(value)
signal xp_gain
signal level_up



func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func _ready():
	self.health = max_health

func LevelUp():
	level += 1
	speed += .1
	strength += .5
	set_max_health(max_health + 1)
	self.health = max_health
	emit_signal("level_up")

func OnKill(experience_gained):
	leveled = false
	experience += experience_gained
	while experience >= experience_required:
		LevelUp()
		experience -= experience_required
		leveled = true
	PlayerStats.coins += 1
	emit_signal("xp_gain")
