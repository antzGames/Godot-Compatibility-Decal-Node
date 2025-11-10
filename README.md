# Compatibility Decal Node Plugin for Godot 4.5
This plugin provides both instanced and non-instanced decal node functionality for the Compatibility Renderer in Godot 4.5, packaged as an easy-to-use plugin.

Included Demo scene:

![stencil00](https://github.com/user-attachments/assets/d6378894-f7c8-4d6e-b886-b40d4e918829)

1000 instanced decal bullet holes:

![stencil0](https://github.com/user-attachments/assets/ed0e4cd9-2a2e-4e97-bb2a-eb97605ce32e)

## YouTube Tutorial and Examples

See the first tutorial at: https://youtu.be/8_vL1B_J56I

See the demos in action and more information: https://youtu.be/8XnH3mT1C-c

Example game using this plugin: https://antzgames.itch.io/little-mage

![example1](https://github.com/user-attachments/assets/31d0e9cb-f94a-4bd3-972d-3032c1ed8136)

## Limitations

- No support for normal maps, ambient occlusion, roughness, metallic, or emission textures.

- Decals are unshaded (no lighting interaction).

- No support for fading curves (start/end with curvature). Only basic start, end, and power levels are available and **only fades upward**.

The nodes do not work with the Forward+ or Mobile renderers. Use Godot's built-in `Decal` node when targeting those renderers.

Tested on Godot 4.4.1 to 4.5.1.

## Features
- Projects decals onto uneven surfaces (e.g., terrain or complex geometry).
- Stencil support, which allows you to exclude specific geometry from recieving decal (such as the player).
- Decals can be projected onto both floors and walls.
- Adds two new nodes to Godot:
  - `DecalCompatibility` extends MeshInstance3D, which should be used when only one decal is needed.
  - `DecalInstanceCompatibility` extends MultiMeshInstance3D, which should be used when you need large amounts of the same decal, like bullet holes.
- No need to modify shaders—fully usable via the Godot editor Inspector.
- Full transparency support.
- Easy fading controls with start, end, and power parameters.
- Individual decal alpha control when using the `DecalInstanceCompatibility` node.
- Fully documented code.
- Includes two demo scenes:
  - `Demo.tscn` shows moving, rotating, fading, distance culling, transparency, color modulating, instancing decal examples.
  - `Instanced.tscn` shows 1000 instanced bullets rendering with just **ONE** draw call.

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

![4](https://github.com/user-attachments/assets/8ed3637e-0325-4e5a-adcc-efd98d95bec3)

## New Nodes

### DecalCompatibility

Use this node if you just need one or two decals.

![2](https://github.com/user-attachments/assets/51fead47-2c6b-4484-aaee-68eceb4aef87)

### DecalInstanceCompatibility

Use this node if you plan to use many copies of the same decal, such as bullet holes.  This allows thousands of decals to be drawn using one draw call. 

`custom_data` is enabled to control the alpha channel per instance, which allows you to control fading of individual decal instances. `custom_data.a` is reserved, but the remaining 3 floats for RGB are available to you.

![1](https://github.com/user-attachments/assets/f3a42b19-b25a-406d-8861-ee7369c639ed)

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

## Planned Features

- Flipbook animation support for animated decals.
