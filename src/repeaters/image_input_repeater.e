note
	description: "Summary description for {IMAGE_INPUT_REPEATER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IMAGE_INPUT_REPEATER

inherit

	WSF_DYNAMIC_MULTI_CONTROL [IMAGE_INPUT]

create
	make_with_tag_name

feature

	create_control_from_tag (tag: STRING): detachable IMAGE_INPUT
		do
			if tag.same_string ("image") then
				create Result.make (Current)
			end
		end

end
