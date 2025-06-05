@tool
extends EditorPlugin

func _ready() -> void:
	ResourceSaver.save(preload("res://addons/decal_compatibility/decal_compatibility.gd"))
	ResourceSaver.save(preload("res://addons/decal_compatibility/decal_instance_compatibility.gd"))

func _enter_tree() -> void:
	# New custom node
	add_custom_type("DecalCompatibility", "MeshInstance3D", preload("res://addons/decal_compatibility/decal_compatibility.gd"), preload("res://addons/decal_compatibility/Decal.svg"))
	add_custom_type("DecalInstanceCompatibility", "MeshInstance3D", preload("res://addons/decal_compatibility/decal_instance_compatibility.gd"), preload("res://addons/decal_compatibility/Decal.svg"))

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type("DecalCompatibility")
	remove_custom_type("DecalInstanceCompatibility")
