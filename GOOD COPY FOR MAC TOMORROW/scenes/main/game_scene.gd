extends Node2D

signal levelup

@export var end_game_screen_packed: PackedScene	

var total_enemies: int 
var killed_enemies: int = 0

func _ready() -> void:
	var enemy_array: Array = get_tree().get_nodes_in_group("enemies")
	total_enemies = enemy_array.size()
	for i in enemy_array:
		i.died.connect(experience_gained)
	var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
	levelup.connect(player.calculate_stats)
	player.game_over.connect(display_end_game_screen)

func enemy_died(exp_reward: int) -> void:
	killed_enemies +=1 
	experience_gained(exp_reward)
	
	if killed_enemies == total_enemies:
		get_tree().change_scene_to_file("res://scenes/main/victory_game_screen.tscn")
		
func experience_gained(exp_gain: int) -> void:
	if PlayerData.level == LevelData.MAX_LEVEL:
		return
	
	var new_experience: int = PlayerData.experience + exp_gain
	if new_experience >= LevelData.LEVEL_THRESHOLDS[PlayerData.level - 1]:
		level_up(new_experience)
	else:
		PlayerData.experience = new_experience


func level_up(new_experience: int) -> void:
	print("yay i got more powerful")
	new_experience -= LevelData.LEVEL_THRESHOLDS[PlayerData.level - 1]
	PlayerData.level += 1
	PlayerData.experience = new_experience
	levelup.emit()
	
	
func display_end_game_screen(victorious: bool) -> void:
	var end_game_screen_scene: Control = end_game_screen_packed.instantiate()
	end_game_screen_scene.victorious = victorious
	
	var scene_handler: Node = get_node("/root/SceneHandler")
	end_game_screen_scene.repeat_level.connect(scene_handler.new_game)
	end_game_screen_scene.main_menu.connect(scene_handler.load_main_menu)
	$UI.add_child(end_game_screen_scene)
	
func _physics_process(delta: float) -> void:
	var parent = $TestMap
	var enemies = parent.find_child("enemies")
	if enemies.get_child_count() == 0:
		await get_tree().process_frame	
		get_tree().change_scene_to_file("res://scenes/main/victory_game_screen.tscn")
		
