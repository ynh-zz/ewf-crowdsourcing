note
	description: "Summary description for {SQL_QUERY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQL_QUERY

inherit

	ANY

	SQL_TABLE_DEFINITION
		redefine
			make,
			query,
			table_definition,
			args
		end

	TUPLE_UTILITIES

create
	make

feature {NONE}

	make (a_table_name: STRING)
		do
			table := a_table_name
			create joins.make (0)
		end

feature

	set_table (subquery: SQL_TABLE_DEFINITION)
		do
			table := subquery
		end

	set_where (condition: SQL_CONDITION)
		do
			where := condition
		end

	set_having (condition: SQL_CONDITION)
		do
			having := condition
		end

	set_order_by (a_order_by: STRING)
		do
			order_by := a_order_by
		end

	set_fields (a_fields: ARRAY [TUPLE])
		do
			fields := a_fields
		end

	set_limit (a_start, a_rows: INTEGER)
		do
			start := a_start
			rows := a_rows
		end

	left_join (td: SQL_TABLE_DEFINITION; cond: SQL_CONDITION)
		do
			joins.extend (create {SQL_JOIN_DEFINITION}.make ("LEFT JOIN", td, cond))
		end

	inner_join (td: SQL_TABLE_DEFINITION; cond: SQL_CONDITION)
		do
			joins.extend (create {SQL_JOIN_DEFINITION}.make ("INNER JOIN", td, cond))
		end

	outer_join (td: SQL_TABLE_DEFINITION; cond: SQL_CONDITION)
		do
			joins.extend (create {SQL_JOIN_DEFINITION}.make ("OUTER JOIN", td, cond))
		end

feature --Build Query

	query_without_limit: STRING
		require
			fields_exist: attached fields
			table_exists: attached table
		do
			Result := "SELECT "
			if attached fields as a_fields and attached table as a_table then
				across
					a_fields as f
				loop
					if f.item.count = 2 and then attached {STRING} f.item.at (2) as expr and then attached {STRING} f.item.at (1) as name then
						Result.append (expr)
						Result.append (" as ")
						Result.append (name)
					elseif f.item.count = 1 and then attached {STRING} f.item.at (1) as name then
						Result.append (name)
					end
					if not f.is_last then
						Result.append (", ")
					end
				end
				Result.append (" FROM ")
				Result.append (a_table.table_definition)
				across
					joins as join
				loop
					Result.append (" ")
					Result.append (join.item.query)
				end
				if attached where as a_where then
					Result.append (" WHERE ")
					Result.append (a_where.expr)
				end
				if attached group_by as a_group_by then
					Result.append (" GROUP BY ")
					Result.append (a_group_by)
				end
				if attached having as a_having then
					Result.append (" HAVING ")
					Result.append (a_having.expr)
				end
				if attached order_by as a_order_by then
					Result.append (" ORDER BY ")
					Result.append (a_order_by)
				end
			end
		end

	query: STRING
		do
			Result := query_without_limit
			if attached start as a_start and attached rows as a_rows then
				Result.append (" LIMIT ")
				Result.append (a_start.out)
				Result.append (", ")
				Result.append (a_rows.out)
			end
		end

	table_definition: STRING
		do
			create Result.make_empty
			Result.append ("(")
			Result.append (query)
			Result.append (")")
			if attached table_alias as a_table_alias then
				Result.append (" as ")
				Result.append (a_table_alias)
			end
		end

	args_without_limits: TUPLE
		do
			Result := []
			if attached table as a then
				Result := a.args
			end
			across
				joins as join
			loop
				Result := concatenation (Result, join.item.args)
			end
			if attached where as a then
				Result := concatenation (Result, a.args)
			end
			if attached having as a then
				Result := concatenation (Result, a.args)
			end
		end

	args: TUPLE
		do
			Result := args_without_limits
		end

feature

	run (database: SQLITE_DATABASE): SQLITE_STATEMENT_ITERATION_CURSOR
		local
			statement: SQLITE_STATEMENT
		do
			create statement.make (query + ";", database)
			Result := statement.execute_new_with_arguments (args)
		end

	count_total (database: SQLITE_DATABASE): INTEGER
		local
			statement: SQLITE_STATEMENT
		do
			create statement.make ("SELECT count(*) FROM (" + query_without_limit + ") as x;", database)
			Result := statement.execute_new_with_arguments (args_without_limits).item.integer_value (1)
		end

feature --Data

	fields: detachable ARRAY [TUPLE]

	table: detachable SQL_TABLE_DEFINITION

	where: detachable SQL_CONDITION

	joins: ARRAYED_LIST [SQL_JOIN_DEFINITION]

	group_by: detachable STRING

	order_by: detachable STRING

	having: detachable SQL_CONDITION

	start: detachable INTEGER

	rows: detachable INTEGER

end
