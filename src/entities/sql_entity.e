note
	description: "Summary description for {SQL_ENTITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SQL_ENTITY

inherit

	WSF_ENTITY

create
	make, make_from_sqlite_result_row

feature {NONE} -- Initialization

	make
		do
			create data.make (2)
		end

	make_from_sqlite_result_row (row: SQLITE_RESULT_ROW; a_fields: ARRAY [TUPLE])
		local
			index: NATURAL_32
			value: detachable ANY
		do
			create data.make (row.count.as_integer_32)
			across
				a_fields as f
			loop
				index := f.cursor_index.as_natural_32
				value := row.value (index)
				if attached {CELL [ANY]} value as cell then
					value := cell.item
				end
				if attached {READABLE_STRING_GENERAL} f.item.at (1) as s then
					data.put (value, s)
				end
			end
		end

feature {NONE} -- DATA

	data: HASH_TABLE [detachable ANY, READABLE_STRING_GENERAL]

feature -- Access

	put (value: detachable ANY; a_field: READABLE_STRING_GENERAL)
		do
			if attached value as v then
				data [a_field] := v
			end
		end

	item alias "[]" (a_field: READABLE_STRING_GENERAL): detachable ANY assign put
			-- <Precursor>
		do
			if data.has (a_field) then
				Result := data [a_field]
			end
		end

	get_string (a_field: READABLE_STRING_GENERAL): STRING
		do
			if attached {STRING} item (a_field) as str then
				Result := str
			else
				create Result.make_empty
			end
		end

	get_integer (a_field: READABLE_STRING_GENERAL): INTEGER_64
		do
			if attached {INTEGER_64} item (a_field) as int then
				Result := int
			end
		end

	get_real (a_field: READABLE_STRING_GENERAL): REAL_64
		do
			if attached {REAL_64} item (a_field) as real then
				Result := real
			end
		end

feature -- Store

	save (database: SQLITE_DATABASE; table: STRING)
		local
			list: LINKED_LIST [STRING]
			statement: SQLITE_INSERT_STATEMENT
			insert: STRING
			values: STRING
		do
			create insert.make_from_string ("INSERT INTO " + table + " (")
			create values.make_from_string (") VALUES (")
			across
				data as c
			loop
				if attached c.item as elem then
					insert.append (c.key.as_string_32)
					values.append ("'" + elem.out + "'")
					if not c.is_last then
						insert.append (", ")
						values.append (", ")
					end
				end
			end
			create statement.make (insert + values + ");", database)
			statement.execute
		end

end
