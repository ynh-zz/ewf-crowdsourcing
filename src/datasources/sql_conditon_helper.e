note
	description: "Summary description for {SQL_CONDITON_HELPER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQL_CONDITON_HELPER
create
	make
feature {NONE}

	make(a_field:STRING;a_parent:SQL_CONDITIONS)
	do
		field:=a_field
		parent:=a_parent
	end

feature
	equals (a_value: ANY)
		do
			parent.equals (field, a_value)
		end

	not_equals (a_value: ANY)
		do
			parent.not_equals (field, a_value)
		end

	less_than (a_value: ANY)
		do
			parent.less_than (field, a_value)
		end

	less_or_equal_than (a_value: ANY)
		do
			parent.less_or_equal_than (field, a_value)
		end

	greater_than (a_value: ANY)
		do
			parent.greater_than (field, a_value)
		end

	greater_or_equal_than (a_value: ANY)
		do
			parent.greater_or_equal_than (field, a_value)
		end

	sql_like (a_value: STRING)
		do
			parent.sql_like (field, a_value)
		end

	contains (a_value: STRING)
		do
			parent.contains (field, a_value)
		end

	start_with (a_value: STRING)
		do
			parent.start_with (field, a_value)
		end

	end_with (a_value: STRING)
		do
			parent.end_with (field, a_value)
		end

feature
	field:STRING
	parent: SQL_CONDITIONS
end
