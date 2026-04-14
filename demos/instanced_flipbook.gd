extends Node3D

@onready var title_label: Label = $UI/Title
@onready var label: Label = $UI/Label
@export var title: String
@export var next_scene: PackedScene

@onready var decal_instance_compatibility: DecalInstanceCompatibility = $CompatibilityDecals/DecalInstanceExplosionsOneShot
@onready var decal_instance_skulls: DecalInstanceCompatibility = $CompatibilityDecals/DecalInstanceSkulls

var node3D: Node3D = Node3D.new()
var location: Vector3 = Vector3.ZERO
var timer: float
var i: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title_label.text = title
	randomize()
	randomizeInstances()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	label.text = str("There are 1000 pooled explosions, and 2000 skulls\nDraw calls: ", Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),"\nFPS: ", Engine.get_frames_per_second(),"\nUse WASD + QE + Right Mouse Button for Camera control")
	if timer > 0.01:
		timer = 0
		decal_instance_compatibility.reset_one_shot(i)
		i += 1
		if i > decal_instance_compatibility.multimesh.visible_instance_count - 1: i = 0

func randomizeInstances():
	decal_instance_compatibility.multimesh.visible_instance_count = decal_instance_compatibility.multimesh.instance_count
	for instance in decal_instance_compatibility.multimesh.instance_count:
		location.y = -0.05
		location.x = randf() * 20 - 10
		location.z = randf() * 20 - 10
		node3D.rotation = Vector3.ZERO
		node3D.rotate_y(randf_range(0,TAU))
		node3D.position = location
		decal_instance_compatibility.multimesh.set_instance_transform(instance, node3D.transform)

	decal_instance_skulls.multimesh.visible_instance_count = decal_instance_compatibility.multimesh.instance_count
	for instance in decal_instance_skulls.multimesh.instance_count:
		location.y = -0.05
		location.x = randf() * 20 - 10
		location.z = randf() * 20 - 10
		node3D.rotation = Vector3.ZERO
		node3D.rotate_y(randf_range(0,TAU))
		node3D.position = location
		decal_instance_skulls.multimesh.set_instance_transform(instance, node3D.transform)
		decal_instance_skulls.multimesh.set_instance_custom_data(
			instance, 
			Color(0, randf_range(0, decal_instance_skulls.x_frames * decal_instance_skulls.y_frames - 1),
			0, 1))
		
func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel") and OS.get_name() != "Web":
		get_tree().quit()
	elif event.is_action_pressed("next_scene"):
		if next_scene: get_tree().change_scene_to_packed(next_scene)
