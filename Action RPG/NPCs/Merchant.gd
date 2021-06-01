extends StaticBody2D

var canTalk = false


func _process(delta: float) -> void:
	pass

func _ready() -> void:
	pass


func _on_Area2D_area_entered(area: Area2D) -> void:
	canTalk = true


func _on_Area2D_area_exited(area: Area2D) -> void:
	canTalk = false
