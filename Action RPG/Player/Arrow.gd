extends KinematicBody2D

var velocity = Vector2.ZERO



onready var timer = $Timer
onready var collision = $CollisionShape2D

func _ready() -> void:
	timer.start()


func _physics_process(delta: float):
	move_and_slide(velocity)
	if timer.is_stopped():
		self.queue_free()
	var isCollision = self.get_slide_count()
	if isCollision > 0:
		self.queue_free()
	
