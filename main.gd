extends Control

@onready var label_timer = get_node("PanelContainer/VBoxContainer/label_timer")
@onready var timer_node = get_node("Timer")
@onready var sound_alert = get_node("notification_sound")
var file_path = "C://shutdown_shedule/settings.cfg"
var skipping = 0
var wait_timer = 20
var reset_skip = 1
var play_sound = 1
var sound_volume = 10.0

func _ready():
	get_tree().root.request_attention()
	if get_cancel_flag():
		if reset_skip == 1:
			reset_skipping()
		if skipping == 1:
			abord()
				
	timer_node.wait_time = wait_timer
	sound_alert.volume_db = sound_volume
	sound_alert.playing = play_sound
	timer_node.start()
	
func _process(_delta):
	var time_text = "[center]Dein PC wird in [color=red]%0.0fs[/color] Heruntergefahren\nmöchtest du dieses abbrechen?[/center]" % (timer_node.time_left)
	label_timer.text = time_text

func get_cancel_flag():
	var config = ConfigFile.new()
	var err = config.load(file_path)
	
	if err != OK:
		new_config()
		return false
	
	skipping = config.get_value("settings", "skip_next_time")
	reset_skip = config.get_value("settings", "reset_next_time")
	wait_timer = config.get_value("settings", "wait_time")
	play_sound = config.get_value("settings", "sound_enable")
	sound_volume = config.get_value("settings", "sound_volume")
	return true
	
func reset_skipping():
	var config = ConfigFile.new()
	var err = config.load(file_path)
	
	if err != OK:
		new_config()
		return
	
	config.set_value("settings", "skip_next_time", 0)
	config.save(file_path)
		
func new_config():
	var config = ConfigFile.new()
	config.set_value("settings", "skip_next_time", 0)
	config.set_value("settings", "reset_next_time", 1)
	config.set_value("settings", "wait_time", 20)
	config.set_value("settings", "sound_enable", 1)
	config.set_value("settings", "sound_volume", 10.0)
	config.save(file_path)

func _on_button_cancel_pressed():
	abord()

func _on_button_shutdown_pressed():
	shutdown_system()

func _on_timer_timeout():
	print("ok")
	shutdown_system()

func shutdown_system():
	OS.execute('shutdown', ['-s', '-t', '"1"'])
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		abord()

func abord():
	OS.execute('shutdown', ['-a'])
	get_tree().quit()
	
		
