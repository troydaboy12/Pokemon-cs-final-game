extends CharacterBody2D

enum State {
	IDLE,
	CHASE,
	RETURN,
	ATTACK,
	DEAD
}


@export_category("Stats")
@export var speed: int = 128
@export var attack_damage: int = 18
@export var attack_speed: float = 1.0
@export var hitpoints:int = 180
@export var aggro_range: float = 256.0
@export var attack_range: float = 80.0
@export_category("Related Scenes")
@export var death_packed: PackedScene

var state: State = State.IDLE

@onready var spawn_point: Vector2 = global_position
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")


func take_damage(damage_taken: int) -> void:
	hitpoints -= damage_taken
	if hitpoints <= 0:
		death()
		
		
		
		
		
func death() -> void:
	var death_scene: Node2D = death_packed.instantiate()
	death_scene .position = global_position + Vector2(0.0, -32.0)
	$Effects.add_child(death_scene)
	queue_free()
