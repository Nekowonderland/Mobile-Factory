----------------- ENERGY LASER BEAM -----------------

-- General Iddle Beam --
local iddleBeam = {}
iddleBeam.type = "beam"
iddleBeam.name = "IddleBeam"
iddleBeam.flags = {"not-on-map"}
iddleBeam.width = 1
iddleBeam.damage_interval = 20
iddleBeam.random_target_offset = true
iddleBeam.action_triggered_automatically = false
iddleBeam.action = nil
local iddleBeamAnim =
{
    filename = "__Mobile_Factory_Graphics__/graphics/beams/IddleBeam.png",
    flags = beam_non_light_flags,
    line_length = 2,
    width = 30,
    height = 30,
    frame_count = 2,
    scale = 1.0,
    animation_speed = 0.025,
    blend_mode = laser_beam_blend_mode
}
local iddleBeamLight =
{
    filename = "__Mobile_Factory_Graphics__/graphics/beams/IddleBeamLight.png",
    draw_as_light = true,
    flags = {"light"},
    line_length = 2,
    width = 30,
    height = 30,
    scale = 1.0,
    animation_speed = 0.025,
    frame_count = 2
}
iddleBeam.graphics_set =
{
    beam =
    {
        head = {layers = {iddleBeamAnim, iddleBeamLight}},
        tail = {layers = {iddleBeamAnim, iddleBeamLight}},
        body = {{layers = {iddleBeamAnim, iddleBeamLight}}}
    }
}
data:extend{iddleBeam}


-- Energy Laser MK1 --

-- Connected Beam --
local mk1ConnectedBeam = {}
mk1ConnectedBeam.type = "beam"
mk1ConnectedBeam.name = "MK1ConnectedBeam"
mk1ConnectedBeam.flags = {"not-on-map"}
mk1ConnectedBeam.width = 1
mk1ConnectedBeam.damage_interval = 20
mk1ConnectedBeam.random_target_offset = true
mk1ConnectedBeam.action_triggered_automatically = false
mk1ConnectedBeam.action = nil
local mk1ConnAnim =
{
    filename = "__Mobile_Factory_Graphics__/graphics/beams/MK1ConnectedBeam.png",
    flags = beam_non_light_flags,
    line_length = 2,
    width = 90,
    height = 90,
    frame_count = 2,
    scale = 1/2.7,
    animation_speed = 0.025,
    blend_mode = laser_beam_blend_mode
}
local mk1ConnLight =
{
    filename = "__Mobile_Factory_Graphics__/graphics/beams/MK1ConnectedBeamLight.png",
    draw_as_light = true,
    flags = {"light"},
    line_length = 2,
    width = 90,
    height = 90,
    scale = 1/2.7,
    animation_speed = 0.025,
    frame_count = 2
}
mk1ConnectedBeam.graphics_set =
{
    beam =
    {
        head = {layers = {mk1ConnAnim, mk1ConnLight}},
        tail = {layers = {mk1ConnAnim, mk1ConnLight}},
        body = {{layers = {mk1ConnAnim, mk1ConnLight}}}
    }
}
data:extend{mk1ConnectedBeam}

-- Send Beam --
local mk1SendBeam = {}
mk1SendBeam.type = "beam"
mk1SendBeam.name = "MK1SendBeam"
mk1SendBeam.flags = {"not-on-map"}
mk1SendBeam.width = 1
mk1SendBeam.damage_interval = 20
mk1SendBeam.random_target_offset = true
mk1SendBeam.action_triggered_automatically = false
mk1SendBeam.action = nil
local mk1SendAnim =
{
    filename = "__Mobile_Factory_Graphics__/graphics/beams/MK1SendBeam.png",
    flags = beam_non_light_flags,
    line_length = 4,
    width = 90,
    height = 90,
    frame_count = 4,
    scale = 1/2.7,
    animation_speed = 0.4,
    blend_mode = laser_beam_blend_mode
}
local mk1SendLight =
{
    filename = "__Mobile_Factory_Graphics__/graphics/beams/MK1SendBeamLight.png",
    draw_as_light = true,
    flags = {"light"},
    line_length = 4,
    width = 90,
    height = 90,
    scale = 1/2.7,
    animation_speed = 0.4,
    frame_count = 4
}
mk1SendBeam.graphics_set =
{
    beam =
    {
        head = {layers = {mk1SendAnim, mk1SendLight}},
        tail = {layers = {mk1SendAnim, mk1SendLight}},
        body = {{layers = {mk1SendAnim, mk1SendLight}}}
    }
}
data:extend{mk1SendBeam}


-- Quatron Laser MK1 --

-- Connected Beam --
local mk1QuatronConnectedBeam = {}
mk1QuatronConnectedBeam.type = "beam"
mk1QuatronConnectedBeam.name = "MK1QuatronConnectedBeam"
mk1QuatronConnectedBeam.flags = {"not-on-map"}
mk1QuatronConnectedBeam.width = 1
mk1QuatronConnectedBeam.damage_interval = 20
mk1QuatronConnectedBeam.random_target_offset = true
mk1QuatronConnectedBeam.action_triggered_automatically = false
mk1QuatronConnectedBeam.action = nil
local mk1QConnAnim =
{
    filename = "__Mobile_Factory_Graphics__/graphics/beams/MK1QuatronConnectedBeam.png",
    flags = beam_non_light_flags,
    line_length = 2,
    width = 90,
    height = 90,
    frame_count = 2,
    scale = 1/2.7,
    animation_speed = 0.025,
    blend_mode = laser_beam_blend_mode
}
local mk1QConnLight =
{
    filename = "__Mobile_Factory_Graphics__/graphics/beams/MK1ConnectedBeamLight.png",
    draw_as_light = true,
    flags = {"light"},
    line_length = 2,
    width = 90,
    height = 90,
    scale = 1/2.7,
    animation_speed = 0.025,
    frame_count = 2
}
mk1QuatronConnectedBeam.graphics_set =
{
    beam =
    {
        head = {layers = {mk1QConnAnim, mk1QConnLight}},
        tail = {layers = {mk1QConnAnim, mk1QConnLight}},
        body = {{layers = {mk1QConnAnim, mk1QConnLight}}}
    }
}
data:extend{mk1QuatronConnectedBeam}

-- Send Beam --
local mk1QuatronSendBeam = {}
mk1QuatronSendBeam.type = "beam"
mk1QuatronSendBeam.name = "MK1QuatronSendBeam"
mk1QuatronSendBeam.flags = {"not-on-map"}
mk1QuatronSendBeam.width = 1
mk1QuatronSendBeam.damage_interval = 20
mk1QuatronSendBeam.random_target_offset = true
mk1QuatronSendBeam.action_triggered_automatically = false
mk1QuatronSendBeam.action = nil
local mk1QSendAnim =
{
    filename = "__Mobile_Factory_Graphics__/graphics/beams/MK1QuatronSendBeam.png",
    flags = beam_non_light_flags,
    line_length = 4,
    width = 90,
    height = 90,
    frame_count = 4,
    scale = 1/2.7,
    animation_speed = 0.4,
    blend_mode = laser_beam_blend_mode
}
local mk1QSendLight =
{
    filename = "__Mobile_Factory_Graphics__/graphics/beams/MK1SendBeamLight.png",
    draw_as_light = true,
    flags = {"light"},
    line_length = 4,
    width = 90,
    height = 90,
    scale = 1/2.7,
    animation_speed = 0.4,
    frame_count = 4
}
mk1QuatronSendBeam.graphics_set =
{
    beam =
    {
        head = {layers = {mk1QSendAnim, mk1QSendLight}},
        tail = {layers = {mk1QSendAnim, mk1QSendLight}},
        body = {{layers = {mk1QSendAnim, mk1QSendLight}}}
    }
}
data:extend{mk1QuatronSendBeam}
