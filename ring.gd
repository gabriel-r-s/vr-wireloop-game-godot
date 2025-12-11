class_name Ring
extends RigidBody3D

signal shock
signal win

@export var nudge_min_force := 0.01
@export var nudge_max_force := nudge_min_force + 0.05
@export var nudge_dev := 0.01
@export var default_gravity_scale := 0.1

var grab_state: bool = false

func grab() -> void:
    grab_state = true
    gravity_scale = 0.0
    linear_velocity = Vector3.ZERO
    angular_velocity = Vector3.ZERO

func ungrab() -> void:
    grab_state = false
    gravity_scale = default_gravity_scale
    linear_velocity = Vector3.ZERO
    angular_velocity = Vector3.ZERO

func _ready() -> void:
    gravity_scale = default_gravity_scale
    grab_state = false

func _physics_process(_delta: float) -> void:
    if Input.is_action_just_pressed("Nudge"):
        var v := Vector3.UP
        v.x += randf_range(-nudge_dev, nudge_dev)
        v.z += randf_range(-nudge_dev, nudge_dev)
        v = v.normalized() * randf_range(nudge_min_force, nudge_max_force)
        apply_impulse(v)

    if global_position.y < -1.0:
        shock.emit()
        ungrab()

    for body in get_colliding_bodies():
        if body.has_meta("wire"):
            shock.emit()
            ungrab()
        if body.has_meta("win"):
            win.emit()
            ungrab()


