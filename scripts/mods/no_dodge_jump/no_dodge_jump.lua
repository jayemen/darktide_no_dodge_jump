local mod = get_mod("no_dodge_jump")
local input_service_path = "scripts/managers/input/input_service"

mod:hook_require(input_service_path, function(instance)
    mod:hook(instance, "_get", function(func, self, action_name, ...)
        if action_name ~= "jump" then
            return func(self, action_name, ...)
        end
        
        local jump = func(self, "jump")
        local back = func(self, "move_backward") ~= 0
        local left = func(self, "move_left") ~= 0
        local right = func(self, "move_right") ~= 0
        return jump and not back and not left and not right
    end)
end)
