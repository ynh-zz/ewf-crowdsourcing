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
	make_from_sqlite_result_row

feature {NONE}

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

	item alias "[]" (a_field: READABLE_STRING_GENERAL): detachable ANY
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

end
