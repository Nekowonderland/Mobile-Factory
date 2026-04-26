-- ORE CLEANER BEAMS --

-- Collect Beam --
ocB = {}
ocB.name = "OCBeam"
ocB.type = "beam"
ocB.flags = {"not-on-map"}
ocB.damage_interval = 20
ocB.random_target_offset = false
ocB.action_triggered_automatically = false
ocB.width = 2
ocB.direction_count = 1

local ocBHeadAnim =
{
    filename = "__Mobile_Factory_Graphics__/graphics/Alpha.png",
    width = 1,
    height = 1,
    line_length = 10,
    frame_count = 10,
    animation_speed = 1/15,
    scale = 2
}
local ocBBodyAnim =
{
    filename = "__Mobile_Factory_Graphics__/graphics/beams/OCbeam.png",
    width = 10,
    height = 10,
    line_length = 10,
    frame_count = 10,
    animation_speed = 1/15,
    scale = 2
}
ocB.graphics_set =
{
    beam =
    {
        head = ocBHeadAnim,
        tail = ocBHeadAnim,
        body = {ocBBodyAnim}
    }
}
data:extend{ocB}


-- Send big Beam --
ocBB = {}
ocBB.name = "OCBigBeam"
ocBB.type = "beam"
ocBB.flags = {"not-on-map"}
ocBB.damage_interval = 20
ocBB.random_target_offset = false
ocBB.action_triggered_automatically = false
ocBB.width = 5
ocBB.direction_count = 1

local ocBBHeadAnim =
{
    filename = "__Mobile_Factory_Graphics__/graphics/Alpha.png",
    width = 1,
    height = 1,
    line_length = 16,
    frame_count = 16,
    animation_speed = 1,
    scale = 2
}
local ocBBBodyAnim =
{
    filename = "__Mobile_Factory_Graphics__/graphics/beams/OCBigBeam.png",
    width = 8,
    height = 12,
    line_length = 16,
    frame_count = 16,
    animation_speed = 1,
    scale = 5
}
ocBB.graphics_set =
{
    beam =
    {
        head = ocBBHeadAnim,
        tail = ocBBHeadAnim,
        body = {ocBBBodyAnim}
    }
}
data:extend{ocBB}
