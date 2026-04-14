# Compatibility Decal Node Plugin for Godot 4
This plugin provides both instanced and non-instanced decal node functionality for the Compatibility Renderer in Godot 4.4-4.6, packaged as an easy-to-use plugin.

Allows thousands of decals to be drawn with one draw call and performs well.  No limits set, unlike Godot's Compatibility/Mobile Decal limits of Max 8 decals per surface and max 64 decals per frame.

> [!IMPORTANT]  
> There is currently a PR to get Decal support for the Compatibility Renderer, with the same support as the Mobile renderer (Max 8 decals per surface, max 64 decals per frame): https://github.com/godotengine/godot/pull/118070 which will close https://github.com/godotengine/godot-proposals/discussions/12903 which I actively was trying to push.  If you need to project thousands of decals on a mesh, then my solution is still helpful.

Included Demo scene:

<img width="962" height="563" alt="demo" src="https://github.com/user-attachments/assets/9e101ea3-d81e-4f6b-8629-647c09d98d33" />

2000 Animated Instanced Skeletons + 1000 pooled Animated Explosions

<img width="962" height="563" alt="flipbook" src="https://github.com/user-attachments/assets/e0078043-5f10-428e-ad0b-6f669a009665" />

1000 instanced decal bullet holes:

![stencil0](https://github.com/user-attachments/assets/ed0e4cd9-2a2e-4e97-bb2a-eb97605ce32e)

## YouTube Tutorial and Examples

See the first tutorial at: https://youtu.be/8_vL1B_J56I

See the demos in action and more information: https://youtu.be/8XnH3mT1C-c

Example game using this plugin: https://antzgames.itch.io/little-mage

![example1](https://github.com/user-attachments/assets/31d0e9cb-f94a-4bd3-972d-3032c1ed8136)

## Features
- **`No limits`** like Godot's Decal implementation for Compatibility/Mobile renderers which limits decals to 8 decals per mesh, **AND** 64 decals per frame.  With my solution you can use thousands of decals **PER MESH**.
- Projects decals onto uneven surfaces (e.g., terrain or complex geometry).
- Stencil support, which allows you to exclude specific geometry from recieving decal (such as the player).
- Decals can be projected onto both floors and walls.
- Instanced Flipbook animation support, with:
  - Speed control.
  - Both `Looping` (the default) and `Oneshot` support.
  - Easy oneshot reset.
  - Frame offset support to randomize looping animation.
- Adds two new nodes to Godot:
  - `DecalCompatibility` extends MeshInstance3D, which should be used when only one decal is needed.
  - `DecalInstanceCompatibility` extends MultiMeshInstance3D, which should be used when you need large amounts of the same decal, like bullet holes.
- No need to modify shaders - fully usable via the Godot editor Inspector.
- Full transparency support.
- Easy fading controls with start, end, and power parameters.
- Individual decal alpha control when using the `DecalInstanceCompatibility` node.
- Fully documented code.
- Includes three demo scenes:
  - `demo.tscn` shows moving, rotating, fading, distance culling, transparency, color modulating, instancing decal examples.
  - `instanced_flipbook.tscn` shows 2000 instanced animated skulls 1000 oneshot explosions, rendering with just **TWO** draw calls.
  - `instanced.tscn` shows 1000 instanced bullets rendering with just **ONE** draw call.

## Limitations

- No support for normal maps, ambient occlusion, roughness, metallic, or emission textures.
- Decals are unshaded (no lighting interaction).

As of V1.1 of the plugin, you can now use the plugin with the Forward+ or Mobile renderers, but it is strongly recommended that you use Godot's built-in `Decal` node when targeting those renderers.

Tested on Godot 4.4.1 to 4.6.2.

## Installing

**Option 1**: Use as a project template:
- Download this repository as a ZIP file.
- Extract the ZIP file.
- Import the project from the Godot's project selection screen.

**Option 2**: Add plugin to existing project:
- Download this repository as a ZIP file.
- Extract the ZIP file.
- Copy the `addons` directory from the extracted ZIP file into your Godot project's `res://` filesystem.
- Go to `Project > Project Settings > Plugins` and enable `Decal Compatibility Nodes` plugin as shown below.

<img width="1261" height="306" alt="plugin_enable" src="https://github.com/user-attachments/assets/bc580a39-a8f8-44a4-91b9-798fa359e44c" />

## New Nodes

### DecalCompatibility

Use this node if you just need one or two decals.

<img width="614" height="1025" alt="single" src="https://github.com/user-attachments/assets/a001157f-a21b-46a4-a531-edfb9dd32bce" />

### DecalInstanceCompatibility

Use this node if you plan to use many copies of the same decal, such as bullet holes.  This allows thousands of decals to be drawn using one draw call. 

`custom_data` is used to modify individual decal instances.

 - `custom_data.r` = instanced one_shot timestamp
 - `custom_data.g` = instanced frame offset `[0..(x_frames * y_frames - 1)]`
 - `custom_data.b` = Not used
 - `custom_data.a` = instance alpha of decal: use `fade_out_instance(instance_id, fade_out_time, start_delay)`

<img width="609" height="1075" alt="instanced" src="https://github.com/user-attachments/assets/31d8689d-b7c5-42b7-b377-995baff43087" />

## Using new nodes in your projects

The new nodes are automatically added to Godot.  Just search `Decal` as shown below:

![3](https://github.com/user-attachments/assets/48d924db-f160-4368-bb03-8f06fa275552)

### How to use

Make sure you assign a texture to the decal.  Decal nodes in scenes will have warnings until you assign a texture to it.

Make sure the geometry of the decal size intersects the ground/wall geometry or else you will see nothing. Watch the tutorial video if 
unsure what this means. Video: https://youtu.be/8_vL1B_J56I

By default both projection of the decal and fading happen on the Y-AXIS, which works great on the ground.

If you need to use the decals on walls (like for the bullet holes), then you will need to rotate the decal.  It is up to you to find the normal of the wall, and rotate the decal to the proper rotation.  Watch the tutorial video if unsure what this means. Video: https://youtu.be/8_vL1B_J56I

### Stencil Support 

If you want specific geometry to not receive the decal projection, all you need to do is enable Stencil in the `StandardMaterial3D` of your player or any other object you don't want decals to be projected.

You set up the stencil in the editor as you see below:

<img width="781" height="551" alt="stencil1" src="https://github.com/user-attachments/assets/7ec173e3-f1e2-4d86-8326-5fd58c003940" />

The demos show the result below:

<img width="1237" height="1252" alt="stencil3" src="https://github.com/user-attachments/assets/e9cb770b-1afc-4bb4-bb55-598400e790ed" />
<img width="2617" height="918" alt="stencil2" src="https://github.com/user-attachments/assets/8f7618dd-b1e0-4df6-9108-bd926cc32ec2" />
