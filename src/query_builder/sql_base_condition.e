note
	description: "Summary description for {SQL_CONDITON_EQUALS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQL_BASE_CONDITION

inherit

	SQL_CONDITION

create
	make

feature

	make (a_field, operator: STRING; a_value: ANY)
		do
			a_field.append (" ")
			a_field.append (operator)
			a_field.append (" ?")
			static_expr := a_field
			create static_args.make (1)
			if attached static_args as a_static_args then
				a_static_args.extend (a_value)
			end
		end

end
