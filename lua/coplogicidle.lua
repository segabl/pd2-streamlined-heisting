-- Make cops react more aggressively when appropriate (less stare, more shoot)
local REACT_AIM = AIAttentionObject.REACT_AIM
local REACT_ARREST = AIAttentionObject.REACT_ARREST
local REACT_COMBAT = AIAttentionObject.REACT_COMBAT
local math_min = math.min
local _chk_reaction_to_attention_object_original = CopLogicIdle._chk_reaction_to_attention_object
function CopLogicIdle._chk_reaction_to_attention_object(data, attention_data, ...)
	if not managers.groupai:state():enemy_weapons_hot() then
		return _chk_reaction_to_attention_object_original(data, attention_data, ...)
	end

	local record = attention_data.criminal_record
	local can_arrest = CopLogicBase._can_arrest(data)
	local attention_reaction = attention_data.settings.reaction

	if attention_data.settings.relation == "friend" then
		return attention_reaction
	end

	if not record or not attention_data.is_person then
		if attention_reaction == REACT_ARREST and not can_arrest then
			return REACT_COMBAT
		else
			return attention_reaction
		end
	end

	if attention_data.is_deployable or data.t < record.arrest_timeout then
		return REACT_COMBAT
	end

	if record.status == "dead" or record.being_arrested then
		return math_min(attention_reaction, REACT_AIM)
	end

	if record.status == "disabled" then
		if record.assault_t and record.assault_t - record.disabled_t > 0.6 then
			return REACT_COMBAT
		else
			return math_min(attention_reaction, REACT_AIM)
		end
	end

	if can_arrest and (not record.assault_t or attention_data.unit:base():arrest_settings().aggression_timeout < data.t - record.assault_t) and record.arrest_timeout < data.t and not record.status then
		if attention_data.dis < 2000 then
			for u_key, other_crim_rec in pairs(managers.groupai:state():all_criminals()) do
				local other_crim_attention_info = data.detected_attention_objects[u_key]
				if other_crim_attention_info and (other_crim_attention_info.is_deployable or other_crim_attention_info.verified and other_crim_rec.assault_t and data.t - other_crim_rec.assault_t < other_crim_rec.unit:base():arrest_settings().aggression_timeout) then
					return REACT_COMBAT
				end
			end
			if attention_data.verified then
				return math_min(attention_reaction, REACT_ARREST)
			end
		end
		return math_min(attention_reaction, REACT_AIM)
	end

	return REACT_COMBAT
end
