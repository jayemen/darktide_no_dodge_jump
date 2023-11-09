local mod = get_mod("no_dodge_jump")
local dodge_require_path = "scripts/extension_systems/character_state_machine/character_states/player_character_state_dodging"
local walk_require_path = "scripts/extension_systems/character_state_machine/character_states/player_character_state_walking"

mod:hook_require(dodge_require_path, function(instance) 
    mod:hook(instance, "fixed_update", function(func, self, ...)
        local sideways = self._input_extension:get("move").x ~= 0.0
        local backwards = self._input_extension:get("move").y < 0.0
        local dodge_component = self._dodge_character_state_component
        
        if not sideways and not backwards then
            return func(self, ...)
        else
            local jump_override_time = dodge_component.jump_override_time
            dodge_component.jump_override_time = 0
            local ret = func(self, ...)
            dodge_component.jump_override_time = jump_override_time
            return ret
        end
    end)
end)

mod:hook_require(walk_require_path, function(instance) 
    mod:hook(instance, "fixed_update", function(func, self, ...)
        local sideways = self._input_extension:get("move").x ~= 0.0
        local backwards = self._input_extension:get("move").y < 0.0
        local movement_state_component = self._movement_state_component
        
        if not sideways and not backwards then
            return func(self, ...)
        else
            local can_jump = movement_state_component.can_jump
            movement_state_component.can_jump = false
            local ret = func(self, ...)
            movement_state_component.can_jump = can_jump
            return ret
        end
    end)
end)
