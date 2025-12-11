extends Node

var mesh: MeshInstance3D = null
var static_body: StaticBody3D = null

@export var curve: Curve3D = null

func _ready() -> void:
    init_collision.call_deferred()

func init_collision() -> void:
    await get_tree().process_frame

    for child in get_parent().get_children():
        if child is MeshInstance3D:
            mesh = child
            break

    assert(mesh != null, "Couldn't find child MeshInstance3D!")

    mesh.create_trimesh_collision()
    for child in mesh.get_children():
        if child is StaticBody3D:
            static_body = child
            break

    assert(static_body != null, "Couldn't find child StaticBody3D!")
    static_body.set_meta(&"wire", true)


