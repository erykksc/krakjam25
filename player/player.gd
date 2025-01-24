class_name Player
extends Node3D
#
# # cam look
# @export var lookSensitivity : float = 10.0
# var minLookAngle : float = -90.0
# var maxLookAngle : float = 90.0
# # vectors
# var vel : Vector3 = Vector3()
# var mouseDelta : Vector2 = Vector2()
#
# func _ready() -> void:
#     Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
#
# func _process(delta:float)-> void:
#     if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
#         rotation_degrees.x -= mouseDelta.y * lookSensitivity * delta
#         # clamp camera x rotation axis
#         rotation_degrees.x = clamp(rotation_degrees.x, minLookAngle, maxLookAngle)
#
#         # rotate the player along their y-axis
#         rotation_degrees.y -= mouseDelta.x * lookSensitivity * delta
#
#         # reset the mouseDelta vector
#         mouseDelta = Vector2()
#
# func _input(event:InputEvent) -> void:
#   if event is InputEventMouseMotion:
#     mouseDelta = event.relative
#     Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
