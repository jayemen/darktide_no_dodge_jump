local mod = get_mod("no_dodge_jump")
local input_service_path = "scripts/managers/input/input_service"
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")

local function player_movement_valid_for_dodge()
    local player = Managers.player:local_player(1)
    local player_unit = player.player_unit
    local archetype = player:profile().archetype
    local dodge_template = archetype.dodge
    local input_extension = ScriptUnit.extension(player_unit, "input_system")
    local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

    local sprint_character_state_component = unit_data_extension:read_component("sprint_character_state")

    if Sprint.is_sprinting(sprint_character_state_component) then
        return false
    end

    local move = input_extension:get("move")
    local allow_diagonal_forward_dodge = input_extension:get("diagonal_forward_dodge")
    local allow_stationary_dodge = input_extension:get("stationary_dodge")
    local move_length = Vector3.length(move)

    if not allow_stationary_dodge and move_length < dodge_template.minimum_dodge_input then
        return false
    end

    local moving_forward = move.y > 0
    local allow_dodge_while_moving_forward = allow_diagonal_forward_dodge
    local allow_always_dodge = input_extension:get("always_dodge")
    allow_dodge_while_moving_forward = allow_dodge_while_moving_forward or allow_always_dodge

    if not allow_dodge_while_moving_forward and moving_forward then
        return false
    elseif move_length == 0 then
        return true
    else
        local normalized_move = move / move_length
        local x = normalized_move.x
        local y = normalized_move.y

        return allow_always_dodge or y <= 0 or math.abs(x) > 0.707
    end
end

mod:hook_require(input_service_path, function(instance)
    mod:hook(instance, "_get", function(func, self, action_name)
        if action_name ~= "jump" then
            return func(self, action_name)
        end

        return func(self, "jump") and not player_movement_valid_for_dodge()
    end)
end)
