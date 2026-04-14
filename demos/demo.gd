extends Node3D

@onready var title_label: Label = $UI/Title
@onready var label: Label = $UI/Label
@export var title: String
@export var next_scene: PackedScene

@onready var slime_on_floor: DecalCompatibility = $CompatibilityDecals/SlimeOnFloor
@onready var label_3d: Label3D = $CompatibilityDecals/MyLogoDistanceFade/Label3D
@onready var camera_3d: FreeLookCamera = $Camera3D
@onready var my_logo_distance_fade: DecalCompatibility = $CompatibilityDecals/MyLogoDistanceFade
@onready var my_rotating_logo: DecalCompatibility = $CompatibilityDecals/MyRotatingLogo
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var bullet_holes: DecalInstanceCompatibility = $CompatibilityDecals/BulletHoles
@onready var moving_godot: DecalCompatibility = $CompatibilityDecals/MovingGodot
@onready var walking_girl_flip_book: DecalCompatibility = $CompatibilityDecals/WalkingGirlFlipBook
@onready var green_gas_flip_book: DecalCompatibility = $CompatibilityDecals/GreenGasFlipBook
@onready var explosion_flip_book: DecalCompatibility = $CompatibilityDecals/ExplosionFlipBook

var timer: float
var gun_timer: float
var girl_timer: float
var reset_timer: float
var explosion_timer: float
var green_gas_timer: float
var node3D: Node3D = Node3D.new()
var location: Vector3 = Vector3.ZERO
var is_fade_out: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	title_label.text = title
	randomize()
	randomizeInstances()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	slime_on_floor.position.x = sin(timer) + 5.82
	label.text = str("Draw calls: ", Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),"\nFPS: ", Engine.get_frames_per_second(),"\nUse WASD + QE + Right Mouse Button for Camera control")
	label_3d.text = str("Distance Test (10 meters)\nDistance to camera: %.1f" % my_logo_distance_fade.position.distance_to(camera_3d.position))
	my_rotating_logo.rotate_y(-delta/2.0)
	moving_godot.modulate.g = cos(timer)/2.0 + 0.5
	moving_godot.position.z = sin(timer)
	do_bullets(delta)
	do_girl_fade(delta)
	do_explosion(delta)
	
func do_explosion(d: float):
		explosion_timer += d
		green_gas_timer += d

		if green_gas_timer > 7:
			green_gas_timer = 0
			green_gas_flip_book.reset_one_shot()
		
		if explosion_timer > 2:
			explosion_timer = 0
			explosion_flip_book.reset_one_shot()
	
func do_girl_fade(d: float):
	girl_timer += d
	if girl_timer > 1.25:
		girl_timer = 0
		if is_fade_out:
			walking_girl_flip_book.fade_out_instance(1)
			is_fade_out = false
		else:
			walking_girl_flip_book.fade_in_instance(1)
			is_fade_out = true
	
func do_bullets(delta: float):
	gun_timer += delta
	if bullet_holes.multimesh.visible_instance_count >= bullet_holes.multimesh.instance_count:
		reset_timer += delta
		if reset_timer > 5:
			reset_timer = 0
			gun_timer = 0
			randomizeInstances()
	else:
		if gun_timer > 0.75:
			bullet_holes.fade_out_instance(bullet_holes.multimesh.visible_instance_count, 2, 3)
			if bullet_holes.multimesh.visible_instance_count <= bullet_holes.multimesh.instance_count:
				audio_stream_player.play()
			bullet_holes.multimesh.visible_instance_count += 1
			gun_timer = 0
		
func randomizeInstances():
	bullet_holes.reset_all_instances() # remember to reset instances after fading
	bullet_holes.multimesh.visible_instance_count = 0
	bullet_holes.albedo_mix = 0.9
	
	for instance in bullet_holes.multimesh.instance_count:
		location.y = 2.6 + randf() * 2.75 - 1.4
		location.x = 5.1 + randf() * 2.0 - 1.0
		location.z = 1
		node3D.rotation = Vector3.ZERO
		node3D.rotate_x(PI/2)
		node3D.position = location
		
		bullet_holes.multimesh.set_instance_transform(instance, node3D.transform)

func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel") and OS.get_name() != "Web":
		get_tree().quit()
	elif event.is_action_pressed("next_scene"):
		if next_scene: get_tree().change_scene_to_packed(next_scene)
		
