note
	description: "Summary description for {SQL_DATASOURCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SQL_DATASOURCE [T -> SQL_ENTITY create make_from_sqlite_result_row end]

inherit

	WSF_PAGABLE_DATASOURCE [T]

feature {NONE}

	make (db: SQLITE_DATABASE; a_table_name: STRING; a_fields: ARRAY [TUPLE])
		do
			fields := a_fields
			table_name := a_table_name
			page := 1
			page_size := 2
			database := db
		end

feature

	data: ITERABLE [T]
		local
			list: LINKED_LIST [T]
			cursor: SQLITE_STATEMENT_ITERATION_CURSOR
			statement: SQLITE_STATEMENT
			query: STRING
			raw_query: STRING
		do
			create list.make
			query := "SELECT "
			across
				fields as f
			loop
				if f.item.count = 2 and then attached {STRING} f.item.at (1) as expr and then attached {STRING} f.item.at (2) as name then
					query.append (expr)
					query.append (" as ")
					query.append (name)
				elseif f.item.count = 1 and then attached {STRING} f.item.at (1) as name  then
					query.append (name)
				end
				if not f.is_last then
					query.append (", ")
				end

			end
			query.append (" FROM ")
			query.append (table_name)
			create raw_query.make_from_string (query)
			query.append (" LIMIT ")
			query.append (((page - 1)*page_size).out)
			query.append (", ")
			query.append (page_size.out)
			query.append (";")
			create statement.make (query, database)
			cursor := statement.execute_new
			across
				cursor as row
			loop
				list.extend (create {T}.make_from_sqlite_result_row (row.item, fields))
			end
			Result := list
			create statement.make ("SELECT count(*) FROM ("+raw_query+") as x;", database)
			cursor := statement.execute_new
			row_count := cursor.item.integer_value (1)
		end

feature

	table_name: STRING

	fields: ARRAY [TUPLE]

	database: SQLITE_DATABASE

end
