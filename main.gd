extends Node

@export var game_scene: PackedScene

@export var shock_sound_scene: PackedScene
@export var win_sound: AudioStreamPlayer

var game: Node = null
var ring: Ring = null
var wire: Node3D = null
var win: StaticBody3D = null

func _ready() -> void:
    init_game.call_deferred()

func init_game() -> void:
    if game != null:
        remove_child(game)

    game = game_scene.instantiate()
    ring = game.get_node("Ring")
    wire = game.get_node("Wire")
    win = game.get_node("Win")
    win.set_meta("win", true)

    ring.shock.connect(game_over)
    ring.win.connect(game_win)

    add_child(game)

func game_win() -> void:
    win_sound.play()
    init_game()

func game_over() -> void:
    var shock_sound: Node3D = shock_sound_scene.instantiate()
    shock_sound.position = ring.global_position
    add_child(shock_sound)
    init_game()
