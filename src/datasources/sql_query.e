note
	description: "Summary description for {SQL_QUERY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQL_QUERY

inherit

	ANY
		redefine
			out
		end

create
	make

feature {NONE}

	make
		do
		end

feature

	set_table (subquery: SQL_QUERY; a_table_alias: STRING)
		do
			table := subquery.query
			table_args := subquery.args
			table_alias := a_table_alias
		end

	set_table_name (table_name: STRING)
		do
			table := table_name
			table_args := Void
			table_alias := Void
		end

	set_table_name_with_alias (table_name, a_table_alias: STRING)
		do
			table := table_name
			table_args := Void
			table_alias := a_table_alias
		end

	set_join (q_query: STRING)
		do
			join := q_query
			join_args := Void
		end

	set_join_with_arguments (q_query: STRING; a_args: ARRAYED_LIST[ANY])
		do
			join := q_query
			join_args := a_args
		end

	set_where (condition: SQL_CONDITION)
		do
			where := condition.out
			where_args := condition.args
		end

	set_having (condition: SQL_CONDITION)
		do
			having := condition.out
			having_args := condition.args
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
				Result.append (a_table)
				if attached join as a_join then
					Result.append (" ")
					Result.append (a_join)
				end
				if attached where as a_where then
					Result.append (" WHERE ")
					Result.append (a_where)
				end
				if attached group_by as a_group_by then
					Result.append (" GROUP BY ")
					Result.append (a_group_by)
				end
				if attached having as a_having then
					Result.append (" HAVING ")
					Result.append (a_having)
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

	out: STRING
		do
			Result := query
			Result.append (";")
		end

	args_without_limits: ARRAYED_LIST[ANY]
		do
			create Result.make (0)
			if attached table_args as a then
				Result := a
			end
			if attached join_args as a then
				Result := merge (Result, a)
			end
			if attached where_args as a then
				Result := merge (Result, a)
			end
			if attached having_args as a then
				Result := merge (Result, a)
			end
		end

	args: ARRAYED_LIST[ANY]
		do
			Result := args_without_limits

		end

feature --helpers

	merge (a: ARRAYED_LIST[ANY];b:ITERABLE [ANY]): ARRAYED_LIST[ANY]
		do

			Result := a
			across
				b as x
			loop
				Result.extend ( x.item)
			end
		end

feature --Data

	fields: detachable ARRAY [TUPLE]

	table: detachable STRING

	table_args: detachable ARRAYED_LIST[ANY]

	table_alias: detachable STRING

	join: detachable STRING

	join_args: detachable ARRAYED_LIST[ANY]

	where: detachable STRING

	where_args: detachable ARRAYED_LIST[ANY]

	group_by: detachable STRING

	order_by: detachable STRING

	having: detachable STRING

	having_args: detachable ARRAYED_LIST[ANY]

	start: detachable INTEGER

	rows: detachable INTEGER

end
