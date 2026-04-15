extends Node


@onready var data_dir: String = OS.get_user_data_dir().path_join("data.bin")



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
	"difficulty": 5
}



func _ready() -> void:
	pass



func save_data() -> void:
	var file: FileAccess = FileAccess.open(data_dir, FileAccess.WRITE)
	file.store_var(data)
	file.close()



func load_data() -> void:
	if !FileAccess.file_exists(data_dir):
		save_data()
		return
	
	var file: FileAccess = FileAccess.open(data_dir, FileAccess.READ)
	
	if file == null:
		return
	
	data = file.get_var()
	file.close()






	
