note
	description: "Summary description for {PROJECTS_DATASOURCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROJECTS_DATASOURCE

inherit

	SQL_DATASOURCE [SQL_ENTITY]
		redefine
			state,
			set_state
		end

create
	make_default

feature

	make_default (db: SQLITE_DATABASE)
		local
			cond: SQL_CONDITIONS
		do
			make (db)
			search_text := ""
		end

	set_query (q: STRING)
		do
			search_text := q
		end

	build_query
		local
			cond: SQL_CONDITIONS
			a_query: SQL_QUERY
		do
			create a_query.make
			create cond.make_condition ("AND")
			cond ["title"].contains (search_text)
			a_query.set_fields (<<["id"], ["title"], ["description"]>>)
			a_query.set_table_name ("projects")
			a_query.set_where (cond)
			query := a_query
		end

	search_text: STRING
feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	state: WSF_JSON_OBJECT
			-- Return state which contains the search_text
		do
			Result := Precursor
			Result.put_string (search_text, "search_text")
		end

	set_state (new_state: JSON_OBJECT)
			-- Restore search_text from json
		do
			Precursor (new_state)
			if attached {JSON_STRING} new_state.item ("search_text") as new_search_text then
				search_text := new_search_text.item
			end
		end

feature -- Change
end
