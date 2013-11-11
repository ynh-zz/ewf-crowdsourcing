note
	description: "Summary description for {SQL_CONDITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQL_CONDITION

inherit

	ANY

	LIST_UTILITIES

create
	make_from_string

convert
	make_from_string ({STRING})

feature {NONE}

	make_from_string (a_expr: STRING)
		do
			static_expr := a_expr
			create static_args.make (0)
		end

feature

	static_expr: detachable STRING

	static_args: detachable ARRAYED_LIST [detachable ANY]

	args: ARRAYED_LIST [detachable ANY]
		do
			create Result.make (0)
			if attached static_args as ar then
				Result := ar
			end
		end

feature -- Query to string convertion

	expr: STRING
		do
			create Result.make_empty
			if attached static_expr as ex then
				Result := ex
			end
		end

end
