local basics = require("game.characters.char_basics")

local function ability(self)
	factory.create("vampiro#bat_projectile", go.get_position())
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
			if action.released then
				ability(self)
			end
		end
	end
end

return basics