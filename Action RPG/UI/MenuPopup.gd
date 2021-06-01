extends Popup

onready var player = get_node("../../YSort/Player")
var already_paused
var selected_menu

func _ready() -> void:
	pass 


func _input(event):
	if not visible:
		if Input.is_action_just_pressed("menu"):
			#pause game
			get_tree().paused = true
			# Reset the popup
			selected_menu = 0
			change_menu_color()
			# Show popup
			popup()
	else:
		if Input.is_action_just_pressed("ui_down"):
			selected_menu = (selected_menu + 1) % 3;
			change_menu_color()
		elif Input.is_action_just_pressed("ui_up"):
			if selected_menu > 0:
				selected_menu = selected_menu - 1
			else:
				selected_menu = 2
			change_menu_color()
			
		elif Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("ui_accept"):
			match selected_menu:
				0:
					# Resume game
					if not already_paused:
						get_tree().paused = false
					player.set_process_input(true)
					hide()
				1:
					get_tree().change_scene("res://Menu/MainMenu.tscn")
					get_tree().paused = false
				2:
					# Quit game
					get_tree().quit()

func change_menu_color():
	$Resume.color = Color.gray
	$Restart.color = Color.gray
	$Quit.color = Color.gray
	
	match selected_menu:
		0:
			$Resume.color = Color.greenyellow
		1:
			$Restart.color = Color.greenyellow
		2:
			$Quit.color = Color.greenyellow
