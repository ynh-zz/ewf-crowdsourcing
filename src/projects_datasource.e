note
	description: "Summary description for {PROJECTS_DATASOURCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROJECTS_DATASOURCE

inherit

	WSF_PAGABLE_DATASOURCE [PROJECT_ENTITY]
		redefine
			state,
			set_state
		end

create
	make

feature --States

	state: WSF_JSON_OBJECT
			-- Return state which contains the current html and if there is an event handle attached
		do
			Result := Precursor
			Result.put_string (query, create {JSON_STRING}.make_json ("query"))
		end

	set_state (new_state: JSON_OBJECT)
		do
			Precursor (new_state)
			if attached {JSON_STRING} new_state.item (create {JSON_STRING}.make_json ("query")) as new_query then
				query := new_query.item
			end
		end

feature

	make (db: SQLITE_DATABASE)
		do
			page := 1
			page_size := 8
			database := db
			query := ""
		end

	data: ITERABLE [PROJECT_ENTITY]
		local
			list: LINKED_LIST [PROJECT_ENTITY]
			cursor: SQLITE_STATEMENT_ITERATION_CURSOR
		do
			create list.make
			cursor := (create {SQLITE_STATEMENT}.make ("SELECT id,title, description FROM projects", database)).execute_new
			across
				cursor as row
			loop
				list.extend (create {PROJECT_ENTITY}.make_from_sqlite_result_row (row.item))
			end
			Result := list
		end

feature

	set_query (q: STRING)
		do
			query := q
		end

	query: STRING

	database: SQLITE_DATABASE

end
