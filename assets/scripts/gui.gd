extends Control

@onready var master_scene: Node = get_tree().current_scene
@onready var sounds_node: Node = $"../../sounds"
@onready var difficulty_slider_node: HSlider = $main_menu/difficulty/difficulty_slider
@onready var difficulty_label_node: Label = $main_menu/difficulty/difficulty_label
@onready var maze_label_node: Label = $main_menu/statistics/maze_label
@onready var total_time_label_node: Label = $main_menu/statistics/total_time_label
@onready var average_time_label_node: Label = $main_menu/statistics/average_time_label
@onready var best_time_label_node: Label = $main_menu/statistics/best_time_label
@onready var current_time_label_node: Label = $game_ui/current_time_label
@onready var music_on_off_label_node: Label = $main_menu/sound/music_on_off_label
@onready var sfx_on_off_label_node: Label = $main_menu/sound/sfx_on_off_label



func _on_start_button_pressed() -> void:
	if Global.data["sfx_on"]:
		sounds_node.button_tick_sound.play()
	master_scene.start_game()



func _on_pause_button_pressed() -> void:
	if Global.data["sfx_on"]:
		sounds_node.button_tick_sound.play()
	master_scene.toggle_pause()



func _on_main_menu_button_pressed() -> void:
	if Global.data["sfx_on"]:
		sounds_node.button_tick_sound.play()
	master_scene.turn_main_menu()



func _on_difficulty_slider_value_changed(value: float) -> void:
	if Global.data["sfx_on"]:
		sounds_node.slider_tick_sound.play()
	Global.data["difficulty"] = int(value)
	update_statistics_ui()
	Global.save_data_queue()



func _on_music_button_pressed() -> void:
	if Global.data["sfx_on"]:
		sounds_node.button_tick_sound.play()
	Global.data["music_on"] = !Global.data["music_on"]
	update_music_on_off_text()
	Global.save_data_queue()



func _on_sfx_button_pressed() -> void:
	sounds_node.button_tick_sound.play()
	Global.data["sfx_on"] = !Global.data["sfx_on"]
	update_sfx_on_off_text()
	Global.save_data_queue()



func update_music_on_off_text() -> void:
	if Global.data["music_on"]:
		if !Global.music.playing:
			Global.music.play()
		music_on_off_label_node.text = "on"
		music_on_off_label_node.set("theme_override_colors/font_color", Color.GREEN)
	else:
		Global.music.stop()
		music_on_off_label_node.text = "off"
		music_on_off_label_node.set("theme_override_colors/font_color", Color.RED)



func update_sfx_on_off_text() -> void:
	if Global.data["sfx_on"]:
		sfx_on_off_label_node.text = "on"
		sfx_on_off_label_node.set("theme_override_colors/font_color", Color.GREEN)
	else:
		sfx_on_off_label_node.text = "off"
		sfx_on_off_label_node.set("theme_override_colors/font_color", Color.RED)



func update_statistics_ui() -> void:
	difficulty_slider_node.set_value_no_signal(Global.data["difficulty"])
	difficulty_label_node.text = "Difficulty " + str(int(Global.data["difficulty"]))
	
	maze_label_node.text = "Completed Mazes " + str(Global.data["statistics"][Global.data["difficulty"]]["total_maze"])
	total_time_label_node.text = "Total Time " + get_time_text(Global.data["statistics"][Global.data["difficulty"]]["total_time"])
	best_time_label_node.text = "Best Time " + get_time_text(Global.data["statistics"][Global.data["difficulty"]]["best_time"])
	if Global.data["statistics"][Global.data["difficulty"]]["total_maze"] <= 0:
		average_time_label_node.text = "Average Time 0s"
		return
	average_time_label_node.text = "Average Time " + get_time_text(
		Global.data["statistics"][Global.data["difficulty"]]["total_time"] /
		Global.data["statistics"][Global.data["difficulty"]]["total_maze"]
	)



func get_time_text(total_seconds: int) -> String:
	var hours: int = total_seconds / 3600
	var minutes: int = (total_seconds % 3600) / 60
	var seconds: int = total_seconds % 60
	
	if hours > 0:
		return "%02d:%02d:%02dh" % [hours, minutes, seconds]
	elif minutes > 0:
		return "%02d:%02dm" % [minutes, seconds]
	else:
		return "%ds" % seconds



func update_second_timer_text(zero: bool) -> void:
	if zero:
		current_time_label_node.text = "0s"
	else:
		current_time_label_node.text = get_time_text(master_scene.current_time)
