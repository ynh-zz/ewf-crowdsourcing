note
	description: "Summary description for {GOAL_INPUT_REPEATER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GOAL_INPUT_REPEATER

inherit

	WSF_DYNAMIC_MULTI_CONTROL [GOAL_INPUT]

create
	make_with_tag_name

feature

	create_control_from_tag (tag: STRING): detachable GOAL_INPUT
		do
			if tag.same_string ("goal") then
				create Result.make (Current)
			end
		end

end
