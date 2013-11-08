note
	description: "Summary description for {SQL_CONDITIONS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQL_CONDITIONS

inherit

	SQL_CONDITION
		redefine
			expr,
			args
		end

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
			add (create {SQL_BASE_CONDITON}.make (a_field, "=", a_value))
		end

	not_equals (a_field: STRING; a_value: ANY)
		do
			add (create {SQL_BASE_CONDITON}.make (a_field, "!=", a_value))
		end

	less_than (a_field: STRING; a_value: ANY)
		do
			add (create {SQL_BASE_CONDITON}.make (a_field, "<", a_value))
		end

	less_or_equal_than (a_field: STRING; a_value: ANY)
		do
			add (create {SQL_BASE_CONDITON}.make (a_field, "<=", a_value))
		end

	greater_than (a_field: STRING; a_value: ANY)
		do
			add (create {SQL_BASE_CONDITON}.make (a_field, ">", a_value))
		end

	greater_or_equal_than (a_field: STRING; a_value: ANY)
		do
			add (create {SQL_BASE_CONDITON}.make (a_field, ">=", a_value))
		end

	sql_like (a_field: STRING; a_value: STRING)
		do
			add (create {SQL_BASE_CONDITON}.make (a_field, "like", a_value))
		end

	contains (a_field: STRING; a_value: STRING)
		do
			sql_like (a_field, "%%" + a_value + "%%")
		end

	start_with (a_field: STRING; a_value: STRING)
		do
			sql_like (a_field, a_value + "%%")
		end

	end_with (a_field: STRING; a_value: STRING)
		do
			sql_like (a_field, "%%" + a_value)
		end

	add (i: SQL_CONDITION)
		do
			list.extend (i)
		end

	item alias "[]" (key: STRING): SQL_CONDITON_HELPER
		do
			create Result.make (key, Current)
		end

	expr: STRING
		do
			create Result.make_empty
			across
				list as el
			loop
				Result.append ("(")
				Result.append (el.item.expr)
				Result.append (")")
				if not el.is_last then
					Result.append (" ")
					Result.append (operator)
					Result.append (" ")
				end
			end
		end

	args: ARRAYED_LIST [detachable ANY]
		do
			create Result.make (0)
			across
				list as el
			loop
				Result := concatenation (Result, el.item.args)
			end
		end

feature

	operator: STRING

	list: ARRAYED_LIST [SQL_CONDITION]

end
