note
	description: "Summary description for {SQL_JOIN_DEFINITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQL_JOIN_DEFINITION

inherit

	ANY

	LIST_UTILITIES

create
	make

feature {NONE}

	make (ty: STRING; td: SQL_TABLE_DEFINITION; cond: SQL_CONDITION)
		do
			type := ty
			table := td
			condition := cond
		end

feature

	query: STRING
		do
			create Result.make_empty
			Result.append (type)
			Result.append (" ")
			Result.append (table.table_definition)
			Result.append (" ON (")
			Result.append (condition.expr)
			Result.append (")")
		end

	args:  ARRAYED_LIST[detachable ANY]
		do
			Result := concatenation (table.args, condition.args)
		end

	type: STRING

	table: SQL_TABLE_DEFINITION

	condition: SQL_CONDITION

end
