note
	description: "Summary description for {SQL_CONDITON_EQUALS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQL_CONDITON_EQUALS

inherit

	SQL_CONDITION
create
	make
feature
	make(a_field:STRING;a_value:ANY)
	do
		query:=a_field
		query.append(" = ?")
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
