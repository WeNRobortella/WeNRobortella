local basics = require("game.characters.char_basics")

local function ability(self)
    self.character_state["ethereal"] = true
    self.ground_contact = false
	basics.gravity = 0
    timer.delay(2, false, function()
        self.character_state["ethereal"] = false
        basics.gravity = -1900
    end)
end

function basics.cooldown(self, input)
	if input == basics.input_ability then
		lock_input(self, input, 4)
	end
end

function basics.on_input(self, action_id, action)
	if not self.inputs_locked then
        basics.check_input(self, action_id, action)
        if not self.character_state["flying"] and
        not self.character_state["walking"] or
        self.character_state["flying"] and
        not self.character_state["flying_x"] then
            if action_id == basics.input_left then
                basics.walk(self, -action.value, 1)
            elseif action_id == basics.input_right then
                basics.walk(self, action.value, 1)
            end
        elseif action.released then
            self.velocity.x = 0
        end
        if not self.character_state["ethereal"] then
            if action_id == basics.input_jump then
                if action.pressed then
                    basics.jump(self)
                elseif action.released then
                    basics.abort_jump(self)
                end
            end
            if action_id == basics.input_ability and
            not self.locked_inputs[action_id] then
                ability(self)
                basics.cooldown(self, action_id)
            end
        else
            if not self.character_state["flying_y"] then
                if action_id == basics.input_up then
                    basics.walk(self, action.value, 2)
                elseif action_id == basics.input_down then
                    basics.walk(self, -action.value, 2)
                end
            elseif action.released then
                self.velocity.y = 0
            end
        end
	end
end

return basics