extends Camera2D

onready var topLeft = $Limits/TopLeft
onready var bottomRight = $Limits/BottomRight
onready var remoteTransform = get_parent().get_node("YSort/Player/RemoteTransform2D")


func _ready():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = bottomRight.position.y
	limit_right = bottomRight.position.x
	Engine.set_target_fps(Engine.get_iterations_per_second())
	

func _on_Teleporter_body_entered(body: Node) -> void:
	self.reset_smoothing()
	


func _on_Teleporter2_body_entered(body: Node) -> void:
	self.reset_smoothing()
