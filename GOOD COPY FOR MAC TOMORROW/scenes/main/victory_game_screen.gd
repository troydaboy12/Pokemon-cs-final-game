extends Control


signal repeat_level(origin: String)
signal main_menu(origin: String)



var victorious: bool


func _on_replay_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main/game_scene.tscn")


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/main_menu.tscn")
	
