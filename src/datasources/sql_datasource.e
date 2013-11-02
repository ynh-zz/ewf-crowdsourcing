note
	description: "Summary description for {SQL_DATASOURCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SQL_DATASOURCE [T -> SQL_ENTITY create make_from_sqlite_result_row end]

inherit
	SQL_HELPER
	WSF_PAGABLE_DATASOURCE [T]

feature {NONE}

	make (db: SQLITE_DATABASE; a_query: SQL_QUERY)
		do
			query := a_query
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
		do
			create list.make
			query.set_limit(page*page_size-page_size,page_size)
			create statement.make (query.out, database)
			cursor := statement.execute_new_with_arguments (query.args)
			if attached query.fields as fields then
				across
					cursor as row
				loop
					list.extend (create {T}.make_from_sqlite_result_row (row.item, fields))
				end
			end
			Result := list
			create statement.make ("SELECT count(*) FROM (" + query.query_without_limit + ") as x;", database)
			cursor := statement.execute_new_with_arguments (query.args_without_limits)
			row_count := cursor.item.integer_value (1)
		end

feature

	query: SQL_QUERY

	database: SQLITE_DATABASE

end
