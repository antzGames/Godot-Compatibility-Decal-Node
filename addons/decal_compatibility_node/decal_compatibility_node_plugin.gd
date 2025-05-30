@tool
extends EditorPlugin

func _ready() -> void:
#	ResourceSaver.save(preload("res://addons/decal_compatibility_node/decal_compatibility_node.gd"))
	pass

func _enter_tree() -> void:
	# New custom node
	add_custom_type("DecalCompatibility", "MeshInstance3D", preload("res://addons/decal_compatibility_node/decal_compatibility_node.gd"), preload("res://addons/decal_compatibility_node/Decal.svg"))

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type("DecalCompatibility")
