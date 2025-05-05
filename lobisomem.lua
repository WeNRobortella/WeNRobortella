local basics = require("game.characters.char_basics")

local function ability(self)
    if not self.input_buffer[basics.input_left] and
    not self.input_buffer[basics.input_up] and
    not self.input_buffer[basics.input_right] and
    not self.input_buffer[basics.input_down] then
        self.velocity.x = basics.max_speed * self.facing_direction * 5
    end
    if self.input_buffer[basics.input_left] then
        self.velocity.x = basics.max_speed * -5
    elseif self.input_buffer[basics.input_right] then
        self.velocity.x = basics.max_speed * 5
    end
    if self.input_buffer[basics.input_up] then
        self.velocity.y = basics.max_speed * 5
    elseif self.input_buffer[basics.input_down] then
        if not self.ground_contact then
            self.velocity.y = basics.max_speed * -5
        else
            self.ability_denied = true
        end
    end
end

function basics.cooldown(self, input)
	if input == basics.input_ability then
		lock_input(self, input, 1)
        self.inputs_locked = false
        self.velocity = vmath.vector3()
	end
end

function basics.on_input(self, action_id, action)
	if not self.inputs_locked then
        basics.check_input(self, action_id, action)
		if not self.character_state["walking"] then
			if action_id == basics.input_left then
				basics.walk(self, -action.value, 1)
			elseif action_id == basics.input_right then
				basics.walk(self, action.value, 1)
			end
		elseif action.released then
			self.velocity.x = 0
		end
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
			if not self.ability_denied then
				lock_inputs(self, action_id, 0.2)
			else
				self.ability_denied = false
			end
		end
	end
end

return basics