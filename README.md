# Compatibility Decal Node Plugin for Godot 4.4+
This plugin provides both instanced and non-instanced decal node functionality for the Compatibility Renderer in Godot 4.4+, packaged as an easy-to-use plugin.

Included Demo scene:

![2025-06-04 08-27-48](https://github.com/user-attachments/assets/5b13dd90-56f1-450a-a390-1be701a14f54)

1000 instanced decal bullet holes:

![2025-06-04 08-34-10](https://github.com/user-attachments/assets/1e83a684-5287-4b33-8162-3dc33fcadef8)

## YouTube Tutorial

See the first tutorial at: https://youtu.be/8_vL1B_J56I

See the demos in action and more information: https://youtu.be/8XnH3mT1C-c

## Limitations

⚠️This plugin is currently experimental and not recommended for production use.

🕵️ I'm seeking expert-level shader assistance to help resolve the current limitations listed below.

Known limitations:

- No support for normal maps, ambient occlusion, roughness, metallic, or emission textures.

- Decals are unshaded (no lighting interaction).

- The mesh is front-culled as a workaround to prevent decal clipping artifacts.
(This hack addresses the issue where decals disappear when the geometry intersects.)

- No support for fading curves (start/end with curvature). Only basic start, end, and power levels are available.

The nodes do not work with the Forward+ or Mobile renderers. Use Godot's built-in Decal node when targeting those renderers.

Tested on Godot 4.4.1 on Windows (NVIDIA RTX 3050) and Linux (Intel Inegrated Graphics) platforms.

## Features
- Projects decals onto uneven surfaces (e.g., terrain or complex geometry).
- Decals can be projected onto both floors and walls.
- Adds two new nodes to Godot 4.4+:
  - `DecalCompatibility` extends MeshInstance3D, which should be used when only one decal is needed.
  - `DecalInstanceCompatibility` extends MultiMeshInstance3D, which should be used when you need large amounts of the same decal, like bullet holes.
- No need to modify shaders—fully usable via the Godot editor Inspector.
- Full transparency support.
- Easy fading controls with start, end, and power parameters.
- Individual decal alpha control when using DecalInstanceCompatibility.
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

## Planned Features

- Flipbook animation support for animated decals.
