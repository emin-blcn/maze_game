extends CharacterBody2D


@onready var master_scene: Node = get_tree().current_scene
@onready var animated_sprite_node: AnimatedSprite2D = $AnimatedSprite2D



const SPEED: float = 7500.0



var current_direction: String = "down"
var is_cutscene_animation_playing: bool = false
var is_auto_moving: bool = false
var is_auto_moving_animation_finished: bool = false



func _physics_process(delta: float) -> void:
	if is_cutscene_animation_playing:
		if animated_sprite_node.is_playing():
			animated_sprite_node.stop()
		return
	if is_auto_moving:
		auto_movement_animation(delta)
	else:
		player_movement(delta)
	
	move_and_slide()



func player_movement(delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_vector * SPEED * delta
	
	if (position.x <= 10.0 and input_vector.x < 0.0) or (position.x >= 646.0 and input_vector.x > 0.0):
		velocity.x = 0.0
	if position.y >= 878.0 and input_vector.y > 0.0:
		velocity.y = 0.0
	
	if input_vector.x != 0.0:
		if input_vector.x > 0.0:
			current_direction = "right"
		elif input_vector.x < 0.0:
			current_direction = "left"
	else:
		if input_vector.y > 0.0:
			current_direction = "down"
		elif input_vector.y < 0.0:
			current_direction = "up"
	
	var state = "idle_" if input_vector == Vector2.ZERO else "run_"
	animated_sprite_node.play(state + current_direction)



func auto_movement_animation(delta: float) -> void:
	if position.y > -50:
		velocity = Vector2(0, -1) * SPEED * delta
		current_direction = "up"
		animated_sprite_node.play("run_up")
	else:
		velocity = Vector2.ZERO
		if not is_auto_moving_animation_finished:
			is_auto_moving_animation_finished = true
			cutscene_animation_finished()



func cutscene_animation_finished() -> void:
	is_auto_moving = false
	is_cutscene_animation_playing = true
	animated_sprite_node.play("idle_up")
	master_scene.draw_next_level()
