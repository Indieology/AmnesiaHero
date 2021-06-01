extends CanvasLayer

onready var player = $"/root/PlayerStats"
onready var PlayerSprite = get_parent().get_node("YSort/Player")
onready var experience_bar = get_node("ExperienceBar/TextureProgress")
onready var experience_bar_label = get_node("ExperienceBar/TextureProgress/Label")
onready var DeathTimer = $DeathTimer
onready var Barmaid = get_parent().get_node("YSort/NPCs/BarMaid")
onready var FoodVendor = get_parent().get_node("YSort/NPCs/FoodVendor")
onready var Trainer = get_parent().get_node("YSort/NPCs/Merchant")
onready var Blacksmith = get_parent().get_node("YSort/NPCs/BlackSmith")
onready var Farmer = get_parent().get_node("YSort/NPCs/Farmer")
onready var Slime = get_parent().get_node("YSort/NPCs/SlimeStatue")
onready var Frog = get_parent().get_node("YSort/NPCs/FrogStatue")
onready var Knight = get_parent().get_node("YSort/NPCs/KnightStatue")
onready var Buda = get_parent().get_node("YSort/NPCs/BudaStatue")

var stats = PlayerStats

var canTalk = false

func _ready() -> void:
	SetExperienceBar()
	
	#dialogic
	var intro_dialog = Dialogic.start('Prolouge', false)
	var new_dialog = Dialogic.start('first', false)
	
	
	new_dialog.connect("timeline_end", self, 'after_dialog')
	new_dialog.connect("dialogic_signal", self, 'dialogic_signal')
	stats.connect("no_health", self, "death_screen")
	intro_dialog.connect("timeline_end", self, 'after_dialog')
	add_child(intro_dialog)
	PlayerSprite.set_physics_process(false)
	
	
func _process(delta: float) -> void:
	
	canTalk = Barmaid.canTalk
	if canTalk == true:
		if Input.is_action_just_pressed("ui_accept") && PlayerStats.slimes_killed < 5 && PlayerStats.golem_killed == false:
			var new_dialog = Dialogic.start('first', false)
			new_dialog.connect("timeline_end", self, 'after_dialog')
			add_child(new_dialog)
			PlayerSprite.animationState.travel("Idle")
			PlayerSprite.set_physics_process(false)
			canTalk = false
			Barmaid.canTalk = false
		elif Input.is_action_just_pressed("ui_accept") && PlayerStats.slimes_killed >= 5 && PlayerStats.golem_killed == false:
			var second_dialog = Dialogic.start('second', false)
			second_dialog.connect("timeline_end", self, 'after_dialog')
			add_child(second_dialog)
			PlayerSprite.animationState.travel("Idle")
			PlayerSprite.set_physics_process(false)
			canTalk = false
			Barmaid.canTalk = false
		elif Input.is_action_just_pressed("ui_accept") && PlayerStats.golem_killed == true && PlayerStats.slimes_killed >= 5:
			var third_dialog = Dialogic.start('third', false)
			third_dialog.connect("timeline_end", self, 'after_dialog')
			add_child(third_dialog)
			PlayerSprite.animationState.travel("Idle")
			PlayerSprite.set_physics_process(false)
			canTalk = false
			Barmaid.canTalk = false
	canTalk = Trainer.canTalk
	if canTalk == true:
		if Input.is_action_just_pressed("ui_accept"):
			var trainer_dialog = Dialogic.start('TrainerFirst', false)
			trainer_dialog.connect("timeline_end", self, 'after_dialog')
			add_child(trainer_dialog)
			PlayerSprite.animationState.travel("Idle")
			PlayerSprite.set_physics_process(false)
			canTalk = false
			Trainer.canTalk = false
			
			
	canTalk = Farmer.canTalk
	if canTalk == true:
		if Input.is_action_just_pressed("ui_accept")  && PlayerStats.coins < 10:
			var farmer_dialog = Dialogic.start('FarmerFirst', false)
			farmer_dialog.connect("timeline_end", self, 'after_dialog')
			add_child(farmer_dialog)
			PlayerSprite.animationState.travel("Idle")
			PlayerSprite.set_physics_process(false)
			canTalk = false
			Farmer.canTalk = false
		if Input.is_action_just_pressed("ui_accept") && PlayerStats.coins >= 10:
			var farmer_dialog2 = Dialogic.start('FarmerSecond', false)
			farmer_dialog2.connect("timeline_end", self, 'after_dialog')
			add_child(farmer_dialog2)
			PlayerSprite.animationState.travel("Idle")
			PlayerSprite.set_physics_process(false)
			canTalk = false
			Farmer.canTalk = false
			
	canTalk = FoodVendor.canTalk
	if canTalk == true:
		if Input.is_action_just_pressed("ui_accept"):
			var food_dialog = Dialogic.start('FoodFirst', false)
			food_dialog.connect("timeline_end", self, 'after_dialog')
			add_child(food_dialog)
			PlayerSprite.animationState.travel("Idle")
			PlayerSprite.set_physics_process(false)
			canTalk = false
			FoodVendor.canTalk = false
			PlayerStats.health = PlayerStats.max_health
			
	canTalk = Blacksmith.canTalk
	if canTalk == true:
		if Input.is_action_just_pressed("ui_accept") && PlayerStats.skeletons_killed < 5:
			var blacksmith_dialog = Dialogic.start('BlacksmithFirst', false)
			blacksmith_dialog.connect("timeline_end", self, 'after_dialog')
			add_child(blacksmith_dialog)
			PlayerSprite.animationState.travel("Idle")
			PlayerSprite.set_physics_process(false)
			canTalk = false
			Blacksmith.canTalk = false
			
		if Input.is_action_just_pressed("ui_accept") && PlayerStats.skeletons_killed >= 5:
			var blacksmith_dialog2 = Dialogic.start('BlacksmithSecond', false)
			blacksmith_dialog2.connect("timeline_end", self, 'after_dialog')
			add_child(blacksmith_dialog2)
			PlayerSprite.animationState.travel("Idle")
			PlayerSprite.set_physics_process(false)
			canTalk = false
			Blacksmith.canTalk = false
			PlayerStats.has_bow = true
	canTalk = Frog.canTalk
	if canTalk == true:
		if Input.is_action_just_pressed("ui_accept"):
			var frog_dialog = Dialogic.start('Frog', false)
			frog_dialog.connect("timeline_end", self, 'after_dialog')
			add_child(frog_dialog)
			PlayerSprite.animationState.travel("Idle")
			PlayerSprite.set_physics_process(false)
			canTalk = false
			Frog.canTalk = false
	canTalk = Slime.canTalk
	if canTalk == true:
		if Input.is_action_just_pressed("ui_accept"):
			var slime_dialog = Dialogic.start('Slime', false)
			slime_dialog.connect("timeline_end", self, 'after_dialog')
			add_child(slime_dialog)
			PlayerSprite.animationState.travel("Idle")
			PlayerSprite.set_physics_process(false)
			canTalk = false
			Slime.canTalk = false
	canTalk = Knight.canTalk
	if canTalk == true:
		if Input.is_action_just_pressed("ui_accept"):
			var knight_dialog = Dialogic.start('Knight', false)
			knight_dialog.connect("timeline_end", self, 'after_dialog')
			add_child(knight_dialog)
			PlayerSprite.animationState.travel("Idle")
			PlayerSprite.set_physics_process(false)
			canTalk = false
			Knight.canTalk = false
	canTalk = Buda.canTalk
	if canTalk == true:
		if Input.is_action_just_pressed("ui_accept"):
			var buda_dialog = Dialogic.start('Buda', false)
			buda_dialog.connect("timeline_end", self, 'after_dialog')
			add_child(buda_dialog)
			PlayerSprite.animationState.travel("Idle")
			PlayerSprite.set_physics_process(false)
			canTalk = false
			Buda.canTalk = false

func _input(event):
	return

func SetExperienceBar():
	get_node("ExperienceBar/TextureRect/Label").set_text(str(player.level))
	experience_bar.max_value = player.experience_required
	experience_bar.value = player.experience
	experience_bar_label.set_text(str(player.experience * 100 / player.experience_required) + "%")
	
func UpdateExperienceBar(leveled):
	if leveled == true:
		experience_bar.max_value = player.experience_required
		get_node("ExperienceBar/TextureRect/Label").set_text(str(player.level))
	else:
		pass
	experience_bar.value = player.experience
	experience_bar_label.set_text(str(player.experience * 100 / player.experience_required) + "%")
	get_node("Amount").set_text(str(PlayerStats.coins))

func death_screen():
	DeathTimer.start(3)
	get_node("DeathScreen").show()
	get_node("DeathScreen/Label").show()
	yield(DeathTimer,"timeout")
	PlayerStats.max_health = 4
	PlayerStats.health = PlayerStats.max_health
	PlayerStats.level = 1
	PlayerStats.experience = 0
	PlayerStats.experience_required = 143
	PlayerStats.leveled = false
	PlayerStats.slimes_killed = 0
	PlayerStats.skeletons_killed = 0
	PlayerStats.golem_killed = false
	PlayerStats.coins = 0
	PlayerStats.has_bow = false
	get_tree().change_scene("res://Menu/MainMenu.tscn")

func after_dialog(timeline_name):
	print('Now you can resume with teh game :)')
	PlayerSprite.set_physics_process(true)

func dialogic_signal(argument):
	if argument == 'user_clicked_yes':
		print('yes!')
