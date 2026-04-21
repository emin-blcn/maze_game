extends CharacterBody2D

const SPEED: float = 125.0

var current_direction: String = "down"
var is_controls_locked: bool = false
var is_auto_movement_animation_called: bool = false
var is_auto_moving: bool = false

@onready var master_scene: Node = get_tree().current_scene
@onready var animated_sprite_node: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_node: CollisionShape2D = $CollisionShape2D



func _physics_process(_delta: float) -> void:
	if is_controls_locked:
		velocity = Vector2.ZERO
		return
	if _is_gameplay_blocked():
		velocity = Vector2.ZERO
		if animated_sprite_node.is_playing():
			animated_sprite_node.stop()
		return
	if is_auto_moving:
		auto_movement_animation()
	else:
		player_movement()
	
	move_and_slide()



func player_movement() -> void:
	var input_vector: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_vector * SPEED
	
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



func _is_gameplay_blocked() -> bool:
	return master_scene.is_pause_menu_open or master_scene.is_transition_active



func lock_controls() -> void:
	is_controls_locked = true



func unlock_controls() -> void:
	is_controls_locked = false
	is_auto_movement_animation_called = false



func auto_movement_animation() -> void:
	if position.y > -50:
		velocity = Vector2(0, -1) * SPEED
		if animated_sprite_node.animation != "run_up":
			animated_sprite_node.play("run_up")
			current_direction = "up"
	else:
		velocity = Vector2.ZERO
		if !is_auto_movement_animation_called:
			is_auto_movement_animation_called = true
			start_level_transition()



func start_level_transition() -> void:
	is_auto_moving = false
	lock_controls()
	animated_sprite_node.play("idle_up")
	master_scene.draw_next_level()



func disable_collision() -> void:
	collision_shape_node.disabled = true



func enable_collision() -> void:
	collision_shape_node.disabled = false
