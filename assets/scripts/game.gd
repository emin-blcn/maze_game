extends Node



const MAZE = preload("res://assets/objects/maze.scn")



@onready var maps_node: Node2D = $node_2d/maps
@onready var grass_tilemap_node: TileMapLayer = $node_2d/maps/grass
@onready var character_node: CharacterBody2D = $node_2d/character
@onready var main_menu_node: Control = $CanvasLayer/gui/main_menu
@onready var difficulty_label_node: Label = $CanvasLayer/gui/main_menu/difficulty/difficulty_label
@onready var difficulty_slider_node: HSlider = $CanvasLayer/gui/main_menu/difficulty/difficulty_slider
@onready var maze_label_node: Label = $CanvasLayer/gui/main_menu/statistics/maze_label
@onready var total_time_label_node: Label = $CanvasLayer/gui/main_menu/statistics/total_time_label
@onready var average_time_label_node: Label = $CanvasLayer/gui/main_menu/statistics/average_time_label
@onready var best_time_label_node: Label = $CanvasLayer/gui/main_menu/statistics/best_time_label
@onready var current_time_label_node: Label = $CanvasLayer/gui/game_ui/current_time_label
@onready var second_timer_node: Timer = $second_timer
@onready var animation_player_node: AnimationPlayer = $AnimationPlayer


var first_open_game: bool = true
var is_menu_button_pressed: bool = false
var is_character_entered_maze: bool = false
var difficulty: int
var total_mazes: int
var total_time: int
var best_time: int
var level: int = 0
var current_time: int = 0



func _ready() -> void:
	character_node.set_physics_process(false)
	randomize()
	update_ui()



func update_ui() -> void:
	difficulty = Global.data["difficulty"]
	total_mazes = Global.data["statistics"][difficulty]["total_maze"]
	total_time = Global.data["statistics"][difficulty]["total_time"]
	best_time = Global.data["statistics"][difficulty]["best_time"]
	
	difficulty_slider_node.value = difficulty
	difficulty_label_node.text = "Difficulty: " + str(int(difficulty))
	
	maze_label_node.text = "Completed Mazes: " + str(total_mazes)
	total_time_label_node.text = "Total Time: " + get_time_text(total_time)
	if total_mazes <= 0:
		average_time_label_node.text = "Average Time: 00:00m"
		return
	average_time_label_node.text = "Average Time: " + get_time_text(total_time / total_mazes)
	best_time_label_node.text = "Best Time: " + get_time_text(best_time)



func get_time_text(total_seconds: int) -> String:
	var hours: int = total_seconds / 3600
	var minutes: int = (total_seconds % 3600) / 60
	var seconds: int = total_seconds % 60
	
	if hours > 0:
		return "%02d:%02d:%02d h" % [hours, minutes, seconds]
	
	elif minutes > 0:
		return "%02d:%02d m" % [minutes, seconds]
	
	else:
		return "%d s" % seconds



func _on_start_button_pressed() -> void:
	if animation_player_node.current_animation != "start_button_pressed":
		animation_player_node.play("start_button_pressed")



func draw_next_level() -> void:
	level += 1
	character_node.get_node("CollisionShape2D").disabled = true
	
	var new_map = MAZE.instantiate()
	new_map.position.y = level * -896.0
	maps_node.add_child(new_map)
	
	var tween: Tween = create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.finished.connect(_on_tween_finished)
	tween.tween_property(maps_node, "position", Vector2(0.0, maps_node.position.y + 896.0), 2.0)
	tween.tween_property(character_node, "position", character_node.position + Vector2(0.0, 896.0), 2.0)



func _on_tween_finished() -> void:
	if level == 1:
		character_node.set_physics_process(true)
		maps_node.remove_child(grass_tilemap_node)
	else:
		maps_node.get_child(0).queue_free()
	character_node.get_node("CollisionShape2D").disabled = false
	character_node.is_auto_moving_animation_finished = false
	character_node.is_cutscene_animation_playing = false
	current_time_label_node.text = "00:00m"



func _on_start_area_body_entered(body: Node2D) -> void:
	if body == character_node and second_timer_node.is_stopped():
		is_character_entered_maze = true
		second_timer_node.start()



func _on_finish_area_body_entered(body: Node2D) -> void:
	if body == character_node:
		is_character_entered_maze = false
		character_node.is_auto_moving = true
		second_timer_node.stop()
		Global.data["statistics"][difficulty]["total_maze"] += 1
		if current_time < Global.data["statistics"][difficulty]["best_time"]:
			Global.data["statistics"][difficulty]["best_time"] = current_time
			animation_player_node.play("new_best_time")
		current_time = 0



func _on_difficulty_slider_value_changed(value: float) -> void:
	Global.data["difficulty"] = int(value)
	update_ui()



func _on_second_timer_timeout() -> void:
	current_time += 1
	current_time_label_node.text = get_time_text(current_time)



func _on_pause_button_pressed() -> void:
	if !is_character_entered_maze or animation_player_node.is_playing():
		return
	
	if second_timer_node.is_stopped():
		second_timer_node.start()
		animation_player_node.play("pause_off")
		character_node.is_cutscene_animation_playing = false
	else:
		second_timer_node.stop()
		animation_player_node.play("pause_on")
		character_node.is_cutscene_animation_playing = true



func _on_main_menu_button_pressed() -> void:
	if !is_menu_button_pressed:
		is_menu_button_pressed = true
		character_node.get_node("CollisionShape2D").disabled = true
		grass_tilemap_node.position.y = maps_node.get_child(0).position.y + 896.0
		maps_node.add_child(grass_tilemap_node)
		
		var tween_2: Tween = create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween_2.finished.connect(_on_tween_2_finished)
		tween_2.tween_property(maps_node, "position", Vector2(0.0, maps_node.position.y - 896.0), 2.0)
		tween_2.tween_property(character_node, "position", character_node.position - Vector2(0.0, 896.0), 2.0)



func _on_tween_2_finished() -> void:
	animation_player_node.play("menu_button_pressed")



func reload_scene():
	get_tree().reload_current_scene()
