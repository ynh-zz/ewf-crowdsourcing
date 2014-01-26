note
	description: "Summary description for {REWARD_INPUT_REPEATER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REWARD_INPUT_REPEATER

inherit

	WSF_DYNAMIC_MULTI_CONTROL [REWARD_INPUT]

create
	make_with_tag_name

feature

	create_control_from_tag (tag: STRING): detachable REWARD_INPUT
		do
			if tag.same_string ("reward") then
				create Result.make (Current)
			end
		end

end
