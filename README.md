# Compatibility Decal Node plugin for Godot 4.4+

Both instanced and non-instanced Decal node functionality for the Godot Compatibility Renderer 
in a plugin format.

## Limitations

Let me know if you can help me fix these limitations.  I need expert level shader expertise for the Compatibility renderer. 
It its current state I would not recommend for serious projects.

- No normal map, ambient occlission, roughness, metallic or emission texture support.
- The decal is unshaded.
- The mesh is front culled.  This is a hack that fixes the issue with other decal shaders that 
dissapear if you clip the decal geomotry.
- New nodes do not work on the Forward+/Mobile renderers, which is a non-issue becasue you should be using Godot's `Decal` node when using the Forward+/Mobile renderers.

## Features

- Decals project onto uneven geometry.
- Decals can be projected on ground or walls.
- 2 Nodes added to Godot 4.4+: `DecalCompatibility` and `DecalInstanceCompatibility` nodes.
- No need to adjust shader.  Godot's editor inspector simplifies usage.
- Full transparency support.
- Easy fading support.
- Complete control over individual instances' alpha when using `DecalInstanceCompatibility` node.
- Documented code.
- 2 Demos included (`Demo.tscn` and `Instanced.tscn`)

## Planned features

- Flipbook (animation) of decal.
