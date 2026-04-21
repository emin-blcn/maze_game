extends Node

const MAP = preload("res://assets/objects/map.scn")

var is_menu_button_pressed: bool = false
var is_character_entered_maze: bool = false
var is_pause_menu_open: bool = false
var is_transition_active: bool = false
var level: int = 0
var current_time: int = 0

@onready var maps_node: Node2D = $node_2d/maps
@onready var gui_node: Control = $CanvasLayer/gui
@onready var sounds_node: Node = $sounds
@onready var grass_tilemap_node: TileMapLayer = $node_2d/maps/grass
@onready var character_node: CharacterBody2D = $node_2d/character
@onready var main_menu_node: Control = $CanvasLayer/gui/main_menu
@onready var second_timer_node: Timer = $second_timer
@onready var animation_player_node: AnimationPlayer = $AnimationPlayer



func _ready() -> void:
	character_node.set_physics_process(false)
	gui_node.update_statistics_ui()
	gui_node.update_music_on_off_text()
	gui_node.update_sfx_on_off_text()



func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		if Global.data["sfx_on"]:
			sounds_node.button_tick_sound.play()
		toggle_pause()



func start_game() -> void:
	if animation_player_node.current_animation != "start_button_pressed":
		animation_player_node.play("start_game")



func draw_next_level() -> void:
	is_transition_active = true
	level += 1
	character_node.disable_collision()
	
	var new_map = MAP.instantiate()
	new_map.position.y = level * -896.0
	maps_node.add_child(new_map)
	
	var tween: Tween = create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.finished.connect(_on_tween_finished)
	tween.tween_property(maps_node, "position", Vector2(0.0, maps_node.position.y + 896.0), 2.0)
	tween.tween_property(character_node, "position", character_node.position + Vector2(0.0, 896.0), 2.0)
	if Global.data["sfx_on"]:
		sounds_node.transition_sound.play()



func _on_tween_finished() -> void:
	is_transition_active = false
	if level == 1:
		character_node.set_physics_process(true)
		maps_node.remove_child(grass_tilemap_node)
	else:
		maps_node.get_child(0).queue_free()
	character_node.enable_collision()
	character_node.unlock_controls()
	gui_node.update_second_timer_text(true)



func _on_start_area_body_entered(body: Node2D) -> void:
	if body == character_node and second_timer_node.is_stopped():
		character_entered_maze()



func _on_finish_area_body_entered(body: Node2D) -> void:
	if body == character_node:
		character_finished_maze()



func _on_second_timer_timeout() -> void:
	current_time += 1
	gui_node.update_second_timer_text(false)



func character_entered_maze() -> void:
	if Global.data["sfx_on"]:
		sounds_node.tick_tock_sound.play()
	is_character_entered_maze = true
	second_timer_node.start()



func character_finished_maze() -> void:
	if Global.data["sfx_on"]:
		sounds_node.bell_blip_sound.play()
	is_character_entered_maze = false
	character_node.is_auto_moving = true
	second_timer_node.stop()
	
	Global.data["statistics"][Global.data["difficulty"]]["total_maze"] += 1
	Global.data["statistics"][Global.data["difficulty"]]["total_time"] += current_time
	
	if Global.data["statistics"][Global.data["difficulty"]]["best_time"] == 0:
		Global.data["statistics"][Global.data["difficulty"]]["best_time"] = current_time
	else:
		if Global.data["statistics"][Global.data["difficulty"]]["best_time"] > current_time:
			Global.data["statistics"][Global.data["difficulty"]]["best_time"] = current_time
			animation_player_node.play("new_best_time")
	Global.save_data()
	current_time = 0



func turn_main_menu() -> void:
	if !is_menu_button_pressed:
		if Global.data["sfx_on"]:
			sounds_node.transition_sound.play()
		is_menu_button_pressed = true
		is_transition_active = true
		character_node.disable_collision()
		grass_tilemap_node.position.y = maps_node.get_child(0).position.y + 896.0
		maps_node.add_child(grass_tilemap_node)
		$node_2d/green_screen.visible = false
		animation_player_node.play("turn_main_menu")
		
		var tween_2: Tween = create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tween_2.tween_property(maps_node, "position", Vector2(0.0, maps_node.position.y - 896.0), 2.0)
		tween_2.tween_property(character_node, "position", character_node.position - Vector2(0.0, 896.0), 2.0)



func toggle_pause() -> void:
	if is_menu_button_pressed or animation_player_node.is_playing() or character_node.is_auto_moving or is_transition_active:
		return
	
	if is_pause_menu_open:
		is_pause_menu_open = false
		if is_character_entered_maze:
			second_timer_node.start()
		animation_player_node.play("pause_off")
	else:
		is_pause_menu_open = true
		if is_character_entered_maze:
			second_timer_node.stop()
		animation_player_node.play("pause_on")



func reload_scene():
	get_tree().reload_current_scene()
