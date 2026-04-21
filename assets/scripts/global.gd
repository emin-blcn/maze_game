extends Node

var data: Dictionary = {
	"statistics": [
		{},
		{"total_maze": 0, "total_time": 0, "best_time": 0},
		{"total_maze": 0, "total_time": 0, "best_time": 0},
		{"total_maze": 0, "total_time": 0, "best_time": 0},
		{"total_maze": 0, "total_time": 0, "best_time": 0},
		{"total_maze": 0, "total_time": 0, "best_time": 0},
		{"total_maze": 0, "total_time": 0, "best_time": 0},
		{"total_maze": 0, "total_time": 0, "best_time": 0},
		{"total_maze": 0, "total_time": 0, "best_time": 0},
		{"total_maze": 0, "total_time": 0, "best_time": 0},
		{"total_maze": 0, "total_time": 0, "best_time": 0}
	],
	"difficulty": 5,
	"music_on": true,
	"sfx_on": true
}

@onready var data_dir: String = OS.get_user_data_dir().path_join("data.bin")
@onready var maze: Maze = Maze.new()
@onready var save_data_timer_node: Timer = $save_data_timer
@onready var music: AudioStreamPlayer = $music



func _ready() -> void:
	load_data()



func save_data() -> void:
	var file: FileAccess = FileAccess.open(data_dir, FileAccess.WRITE)
	file.store_var(data)
	file.close()



func save_data_queue() -> void:
	save_data_timer_node.start()



func load_data() -> void:
	if !FileAccess.file_exists(data_dir):
		save_data()
		return
	
	var file: FileAccess = FileAccess.open(data_dir, FileAccess.READ)
	
	if file == null:
		return
	
	data = file.get_var()
	file.close()



func _on_save_data_timer_timeout() -> void:
	save_data()



func _on_music_finished() -> void:
	music.play()
