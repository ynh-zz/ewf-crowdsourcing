note
	description: "Summary description for {SQL_CONDITON_EQUALS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQL_BASE_CONDITON

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
			static_args := [a_value]
		end

end
