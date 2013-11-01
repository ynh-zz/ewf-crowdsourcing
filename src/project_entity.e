note
	description: "Summary description for {PROJECT_ENTITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROJECT_ENTITY

inherit

	WSF_ENTITY

create
	make_from_sqlite_result_row

feature {NONE}

	make_from_sqlite_result_row (row: SQLITE_RESULT_ROW)
		do
			id := row.integer_value (1)
			title := row.string_value (2)
			description := row.string_value (3)
		end

feature -- Access

	id: detachable INTEGER

	title: detachable STRING

	description: detachable STRING

	item (a_field: READABLE_STRING_GENERAL): detachable ANY
			-- <Precursor>
		do
			if a_field.same_string ("id") then
				Result := id
			elseif a_field.same_string ("title") then
				Result := title
			elseif a_field.same_string ("description") then
				Result := description
			end
		end

end
