note
	description: "Summary description for {SQL_SIMPLE_CONDITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQL_SIMPLE_CONDITION

inherit

	SQL_CONDITION

create
	make

convert
	make ({STRING})

feature {NONE}

	make (s: STRING)
		do
			create args.make (0)
			query := s
		end

feature

	query: STRING

	args: ARRAYED_LIST[ANY]

end
