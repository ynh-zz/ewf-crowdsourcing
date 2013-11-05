note
	description: "Summary description for {SQL_CONDITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQL_CONDITION

inherit

	ANY

	TUPLE_UTILITIES

create
	make_from_string

convert
	make_from_string ({STRING})

feature {NONE}

	make_from_string (a_expr: STRING)
		do
			static_expr := a_expr
			static_args := []
		end

feature

	static_expr: detachable STRING

	static_args: detachable TUPLE

	expr: STRING
		do
			create Result.make_empty
			if attached static_expr as ex then
				Result := ex
			end
		end

	args: TUPLE
		do
			Result := []
			if attached static_args as ar then
				Result := ar
			end
		end

end
