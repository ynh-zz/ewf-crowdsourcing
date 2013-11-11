note
	description: "Summary description for {SQL_TABLEDEFINITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQL_TABLE_DEFINITION

create
	make

convert
	make ({STRING})

feature {NONE}

	make (a_table_name: STRING)
		do
			table_name := a_table_name
		end

	make_with_alias (a_table_name, a_table_alias: STRING)
		do
			table_name := a_table_name
			table_alias := a_table_alias
		end

feature 

	table_name: detachable STRING

	table_alias: detachable STRING

	set_alias (a_table_alias: STRING)
		do
			table_alias := a_table_alias
		end

	args: ARRAYED_LIST [detachable ANY]
		do
			create Result.make (0)
		end

feature {SQL_QUERY, SQL_JOIN_DEFINITION} -- Query to string convertion

	query: STRING
		do
			create Result.make_empty
			if attached table_name as t then
				Result.append ("SELECT * FROM ")
				Result.append (t)
				Result.append (" ")
				if attached table_alias as a_table_alias then
					Result.append (" as ")
					Result.append (a_table_alias)
				end
			end
		end

	table_definition: STRING
		do
			create Result.make_empty
			if attached table_name as t then
				Result.append (t)
				if attached table_alias as a_table_alias then
					Result.append (" as ")
					Result.append (a_table_alias)
				end
			end
		end

end
