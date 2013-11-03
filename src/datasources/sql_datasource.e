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

	make (db: SQLITE_DATABASE)
		do 
			page := 1
			page_size := 2
			database := db
		end

feature

	build_query
		deferred
		ensure
			attached query
		end

	data: ITERABLE [T]
		local
			list: LINKED_LIST [T]
			cursor: SQLITE_STATEMENT_ITERATION_CURSOR
			statement: SQLITE_STATEMENT
		do
			if not attached query then
				build_query
			end
			create list.make
			if attached query as a_query then
				a_query.set_limit (page * page_size - page_size, page_size)
				create statement.make (a_query.out, database)
				cursor := statement.execute_new_with_arguments (a_query.args)
				if attached a_query.fields as fields then
					across
						cursor as row
					loop
						list.extend (create {T}.make_from_sqlite_result_row (row.item, fields))
					end
				end
				create statement.make ("SELECT count(*) FROM (" + a_query.query_without_limit + ") as x;", database)
				cursor := statement.execute_new_with_arguments (a_query.args_without_limits)
				row_count := cursor.item.integer_value (1)
			end
			Result := list
		end

feature

	query: detachable SQL_QUERY

	database: SQLITE_DATABASE

end
