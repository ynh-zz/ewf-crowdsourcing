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
	make(a_field,operator:STRING;a_value:ANY)
	do
		query:=a_field
		query.append(" ")
		query.append(operator)
		query.append(" ?")
		value:=a_value
	end


	args: ARRAYED_LIST[ANY]
		do
			create Result.make (1)
			Result.extend (value)
		end

	query:STRING
	value:ANY
end
