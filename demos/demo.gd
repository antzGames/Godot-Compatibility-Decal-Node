extends Node3D

@onready var slime_on_floor: DecalCompatibility = $CompatibilityDecals/SlimeOnFloor
@onready var label_3d: Label3D = $CompatibilityDecals/MyLogoDistanceFade/Label3D
@onready var camera_3d: FreeLookCamera = $Camera3D
@onready var my_logo_distance_fade: DecalCompatibility = $CompatibilityDecals/MyLogoDistanceFade
@onready var my_rotating_logo: DecalCompatibility = $CompatibilityDecals/MyRotatingLogo
@onready var label: Label = $Label
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var bullet_holes: DecalInstanceCompatibility = $CompatibilityDecals/BulletHoles
@onready var moving_godot: DecalCompatibility = $CompatibilityDecals/MovingGodot

var timer: float
var gun_timer: float
var node3D: Node3D = Node3D.new()
var location: Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	randomizeInstance()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	slime_on_floor.position.x = sin(timer) + 5.82
	label.text = str("Draw calls: ", Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),"\nFPS: ", Engine.get_frames_per_second(),"\nUse WASD + QE + Right Mouse Button for Camera control\nESC key to exit (Desktop Only)")
	label_3d.text = str("Distance Test (10 meters)\nDistance to camera: %.1f" % my_logo_distance_fade.position.distance_to(camera_3d.position))
	my_rotating_logo.rotate_y(-delta/2.0)
	moving_godot.modulate.g = cos(timer)/2 + 0.5
	moving_godot.position.z = sin(timer)
	do_bullets(delta)
	
func do_bullets(delta: float):
	gun_timer += delta
	if gun_timer > 2:
		if bullet_holes.multimesh.visible_instance_count >= bullet_holes.multimesh.instance_count:
			bullet_holes.albedo_mix -= delta/2
			if bullet_holes.albedo_mix < 0:
				bullet_holes.multimesh.visible_instance_count = 0
				gun_timer = 0
				randomizeInstance()
		else:
			gun_timer = 0
			bullet_holes.multimesh.visible_instance_count += 1
			audio_stream_player.play()
		
func randomizeInstance():
	bullet_holes.multimesh.visible_instance_count = 0
	bullet_holes.albedo_mix = 0.9
	
	for instance in bullet_holes.multimesh.instance_count:
		location.y = 2.6 + randf() * 2.75 - 1.4
		location.x = 4.9 + randf() * 2.2 - 1.1
		location.z = 1
		node3D.rotation = Vector3.ZERO
		node3D.rotate_x(PI/2)
		node3D.position = location
		
		bullet_holes.multimesh.set_instance_transform(instance, node3D.transform)

func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel") and OS.get_name() != "Web":
		get_tree().quit()
