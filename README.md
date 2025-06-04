# Compatibility Decal Node Plugin for Godot 4.4+
This plugin provides both instanced and non-instanced decal node functionality for the Compatibility Renderer in Godot 4.4+, packaged as an easy-to-use plugin.

![2025-06-04 08-27-48](https://github.com/user-attachments/assets/5b13dd90-56f1-450a-a390-1be701a14f54)

![2025-06-04 08-34-10](https://github.com/user-attachments/assets/1e83a684-5287-4b33-8162-3dc33fcadef8)

## Limitations

⚠️This plugin is currently experimental and not recommended for production use.

🕵️ I'm seeking expert-level shader assistance to help resolve the current issues—particularly for the Compatibility Renderer.

Known limitations:

- No support for normal maps, ambient occlusion, roughness, metallic, or emission textures.

- Decals are unshaded (no lighting interaction).

- The mesh is front-culled as a workaround to prevent decal clipping artifacts.
(This hack addresses the issue where decals disappear when the geometry intersects.)

- No support for fading curves (start/end with curvature). Only basic start, end, and power levels are available.

The nodes do not work with the Forward+ or Mobile renderers. Use Godot's built-in Decal node when targeting those renderers.

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

## Planned Features

- Flipbook animation support for animated decals.
