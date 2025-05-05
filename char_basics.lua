local inputs = {
	-- Player logic

	-- these are the tweaks for the mechanics, feel free to change them for a different feeling
	-- acceleration factor to use when air-borne
	air_acceleration_factor = 0.8,
	-- max speed right/left
	max_speed = 450,
	-- gravity pulling the player down in pixel units
	gravity = -1900,
	-- take-off speed when jumping in pixel units
	jump_takeoff_speed = 1200,

	input_left = hash("left"),
	input_right = hash("right"),
	input_up = hash("up"),
	input_down = hash("down"),
	input_jump = hash("jump"),
	input_ability = hash("ability"),
}

function inputs.check_input(self, action_id, action)
    if action.pressed then
        if not self.input_buffer[action_id] then
            self.input_buffer[action_id] = true
        end
    elseif action.released then
        self.input_buffer[action_id] = nil
    end
end

function inputs.walk(self, direction, axis)
	-- only change facing direction if direction is other than 0
	if axis == 1 then
		if direction ~= 0 then
			self.facing_direction = direction
		end
	-- update velocity and use different velocity on ground and in air
		if self.ground_contact or
		self.character_state["flying"] then
			self.velocity.x = inputs.max_speed * direction
		else
			-- move slower in the air
			self.velocity.x = inputs.max_speed * inputs.air_acceleration_factor * direction
		end
	end
	if axis == 2 then
		if self.character_state["flying"] then
			self.velocity.y = inputs.max_speed * direction
		end
	end
end

function inputs.jump(self)
	-- only allow jump from ground
	-- (extend this with a counter to do things like double-jumps)
	if self.ground_contact then
		-- set take-off speed
		self.velocity.y = inputs.jump_takeoff_speed
		-- play animation
		self.ground_contact = false
	end
end

function inputs.abort_jump(self)
	-- cut the jump short if we are still going up
	if self.velocity.y > 0 then
		-- scale down the upwards speed
		self.velocity.y = self.velocity.y * 0.5
	end
end

return inputs