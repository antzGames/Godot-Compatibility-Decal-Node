extends Node3D

@onready var decal_instance_compatibility: DecalInstanceCompatibility = $CompatibilityDecals/DecalInstanceCompatibility
@onready var label: Label = $Label

var node3D: Node3D = Node3D.new()
var location: Vector3 = Vector3.ZERO
var timer: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	randomizeInstances()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	label.text = str(decal_instance_compatibility.multimesh.visible_instance_count, " out of ", decal_instance_compatibility.multimesh.instance_count, " instances visible.",
		"\nDraw calls: ", Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),"\nFPS: ", Engine.get_frames_per_second(),"\nUse WASD + QE + Right Mouse Button for Camera control\nESC key to exit (Desktop Only)")
	if timer > 1.0/60.0:
		timer = 0
		if decal_instance_compatibility.multimesh.visible_instance_count >= decal_instance_compatibility.multimesh.instance_count:
			decal_instance_compatibility.multimesh.visible_instance_count = 0
		else:
			decal_instance_compatibility.multimesh.visible_instance_count += 1

func randomizeInstances():
	decal_instance_compatibility.multimesh.visible_instance_count = 0
	for instance in decal_instance_compatibility.multimesh.instance_count:
		location.y = -0.05
		location.x = randf() * 20 - 10
		location.z = randf() * 20 - 10
		node3D.rotation = Vector3.ZERO
		node3D.position = location
		decal_instance_compatibility.multimesh.set_instance_transform(instance, node3D.transform)

func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel") and OS.get_name() != "Web":
		get_tree().quit()
