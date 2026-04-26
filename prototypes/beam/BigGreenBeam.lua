------------------------- YELLOW BEAM ---------------------------
beam_tint = {r=0, g=255, b=0}
light_tint = {r=0, g=255, b=0}

ylE = {}
ylE.name = "BigGreenBeam"
ylE.type = "beam"
ylE.flags = {"not-on-map"}
ylE.damage_interval = 20
ylE.random_target_offset = true
ylE.action_triggered_automatically = false
ylE.width = 0.5
ylE.frame_count = 16
ylE.direction_count = 1
ylE.shift = {-0.03125, 0}

ylE.graphics_set =
{
  beam =
  {
    ending =
    {
      filename = "__base__/graphics/entity/beam/tileable-beam-END.png",
      flags = beam_flags or beam_non_light_flags,
      draw_as_glow = true,
      line_length = 4,
      width = 91,
      height = 93,
      frame_count = 16,
      direction_count = 1,
      shift = {-0.078125, -0.046875},
      tint = beam_tint,
      scale = 2
    },
    head =
    {
      filename = "__base__/graphics/entity/beam/beam-head.png",
      flags = beam_flags or beam_non_light_flags,
      draw_as_glow = true,
      line_length = 16,
      width = 45 - 7,
      height = 39,
      frame_count = 16,
      shift = util.by_pixel(-7/2, 0),
      tint = beam_tint,
      blend_mode = blend_mode or beam_blend_mode,
      scale = 4
    },
    tail =
    {
      filename = "__base__/graphics/entity/beam/beam-tail.png",
      flags = beam_flags or beam_non_light_flags,
      draw_as_glow = true,
      line_length = 16,
      width = 45 - 6,
      height = 39,
      frame_count = 16,
      shift = util.by_pixel(6/2, 0),
      tint = beam_tint,
      blend_mode = blend_mode or beam_blend_mode,
      scale = 4
    },
    body =
    {
      {
        filename = "__base__/graphics/entity/beam/beam-body-1.png",
        flags = beam_flags or beam_non_light_flags,
        draw_as_glow = true,
        line_length = 16,
        width = 32,
        height = 39,
        frame_count = 16,
        tint = beam_tint,
        blend_mode = blend_mode or beam_blend_mode,
        scale = 4
      },
      {
        filename = "__base__/graphics/entity/beam/beam-body-2.png",
        flags = beam_flags or beam_non_light_flags,
        draw_as_glow = true,
        line_length = 16,
        width = 32,
        height = 39,
        frame_count = 16,
        tint = beam_tint,
        blend_mode = blend_mode or beam_blend_mode,
        scale = 4
      },
      {
        filename = "__base__/graphics/entity/beam/beam-body-3.png",
        flags = beam_flags or beam_non_light_flags,
        draw_as_glow = true,
        line_length = 16,
        width = 32,
        height = 39,
        frame_count = 16,
        tint = beam_tint,
        blend_mode = blend_mode or beam_blend_mode,
        scale = 4
      },
      {
        filename = "__base__/graphics/entity/beam/beam-body-4.png",
        flags = beam_flags or beam_non_light_flags,
        draw_as_glow = true,
        line_length = 16,
        width = 32,
        height = 39,
        frame_count = 16,
        tint = beam_tint,
        blend_mode = blend_mode or beam_blend_mode,
        scale = 4
      },
      {
        filename = "__base__/graphics/entity/beam/beam-body-5.png",
        flags = beam_flags or beam_non_light_flags,
        draw_as_glow = true,
        line_length = 16,
        width = 32,
        height = 39,
        frame_count = 16,
        tint = beam_tint,
        blend_mode = blend_mode or beam_blend_mode,
        scale = 4
      },
      {
        filename = "__base__/graphics/entity/beam/beam-body-6.png",
        flags = beam_flags or beam_non_light_flags,
        draw_as_glow = true,
        line_length = 16,
        width = 32,
        height = 39,
        frame_count = 16,
        tint = beam_tint,
        blend_mode = blend_mode or beam_blend_mode,
        scale = 4
      }
    }
  },
  ground =
  {
    head =
    {
      filename = "__base__/graphics/entity/laser-turret/laser-ground-light-head.png",
      draw_as_light = true,
      flags = {"light"},
      line_length = 1,
      width = 256,
      height = 256,
      repeat_count = 16,
      scale = 2,
      shift = util.by_pixel(-32, 0),
      animation_speed = 0.5,
      tint = light_tint
    },
    tail =
    {
      filename = "__base__/graphics/entity/laser-turret/laser-ground-light-tail.png",
      draw_as_light = true,
      flags = {"light"},
      line_length = 1,
      width = 256,
      height = 256,
      repeat_count = 16,
      scale = 2,
      shift = util.by_pixel(32, 0),
      animation_speed = 0.5,
      tint = light_tint
    },
    body =
    {
      filename = "__base__/graphics/entity/laser-turret/laser-ground-light-body.png",
      draw_as_light = true,
      flags = {"light"},
      line_length = 1,
      width = 64,
      height = 256,
      repeat_count = 16,
      scale = 2,
      animation_speed = 0.5,
      tint = light_tint
    }
  }
}
ylE.working_sound =
{
  sound =
  {
    filename = "__base__/sound/fight/electric-beam.ogg",
    volume = 1
  },
  max_sounds_per_type = 4
}
data:extend{ylE}
