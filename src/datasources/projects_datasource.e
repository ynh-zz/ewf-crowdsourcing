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
			a_query: SQL_QUERY [SQL_ENTITY]
		do
			create a_query.make ("projects")
			a_query.set_fields (<<["id", "projects.id"], ["title", "projects.title"], ["cname", "categories.name"], ["image", "'http://www.amazingplacesonearth.com/wp-content/uploads/2012/10/Eiffel-Tower-22.jpg'"]>>)
			a_query.left_join ("categories", "categories.id = category_id")
			create cond.make_condition ("AND")
			a_query.set_where (cond)
			cond ["projects.title"].contains (search_text)
			cond ["projects.id"].greater_than (100)
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
