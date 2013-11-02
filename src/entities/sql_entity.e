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
			l_type: INTEGER_32
		do
			create data.make (row.count.as_integer_32)
			across
				a_fields as f
			loop
				index := f.cursor_index.as_natural_32
				l_type := row.type (index)
				value := Void
				if l_type /= {SQLITE_TYPE}.null then
					if l_type = {SQLITE_TYPE}.blob then
						value := row.blob_value (index)
					elseif l_type = {SQLITE_TYPE}.float then
						value := row.real_64_value (index)
					elseif l_type = {SQLITE_TYPE}.integer then
						value := row.integer_64_value (index)
					elseif l_type = {SQLITE_TYPE}.text then
						value := row.string_value (index)
					else
						check
							unknown_type: False
						end
					end
				end
				if attached {READABLE_STRING_GENERAL} f.item.at (1) as s then
					data.put (value, s)
				end
			end
		end

feature {NONE} -- DATA

	data: HASH_TABLE [detachable ANY, READABLE_STRING_GENERAL]

feature -- Access

	item (a_field: READABLE_STRING_GENERAL): detachable ANY
			-- <Precursor>
		do
			if data.has (a_field) then
				Result := data [a_field]
			end
		end

end
