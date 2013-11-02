note
	description: "Summary description for {SQL_CONDITIONS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQL_CONDITIONS

inherit

	SQL_CONDITION

create
	make_condition

feature {NONE}

	make_condition (a_operator: STRING)
		do
			create list.make (0)
			operator := a_operator
		end

feature

	equals (a_field: STRING; a_value: ANY)
		do
			list.extend (create {SQL_CONDITON_EQUALS}.make (a_field, a_value))
		end

	query: STRING
		do
			create Result.make_empty
			across
				list as el
			loop
				Result.append (el.item.out)
				if not el.is_last then
					Result.append (" ")
					Result.append (operator)
					Result.append (" ")
				end
			end
		end

	args: ARRAYED_LIST [ANY]
		do
			create Result.make (0)
			across
				list as el
			loop
				Result := merge (Result, el.item.args)
			end
		end

feature

	operator: STRING

	list: ARRAYED_LIST [SQL_CONDITION]

end
