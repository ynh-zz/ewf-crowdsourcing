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

	set_city (id: INTEGER_64)
		do
			city := id
		end

	set_category (id: INTEGER_64)
		do
			category := id
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
			cond.add ("categories.left >= (SELECT left FROM categories as c WHERE c.id = " + category.out + ")")
			cond.add ("categories.right <= (SELECT right FROM categories as c WHERE c.id = " + category.out + ")")
			if city /= 0 then
				cond ["projects.city_id"].equals(city)
			end
			query := a_query
		end

	search_text: STRING

	city: INTEGER_64

	category: INTEGER_64

feature {WSF_PAGE_CONTROL, WSF_CONTROL} -- State management

	state: WSF_JSON_OBJECT
			-- Return state which contains the search_text
		do
			Result := Precursor
			Result.put_string (search_text, "search_text")
			Result.put_integer (city, "city")
			Result.put_integer (category, "category")
		end

	set_state (new_state: JSON_OBJECT)
			-- Restore search_text from json
		do
			Precursor (new_state)
			if attached {JSON_STRING} new_state.item ("search_text") as new_search_text then
				search_text := new_search_text.item
			end
			if attached {JSON_NUMBER} new_state.item ("city") as new_city then
				city := new_city.item.to_integer_64
			end
			if attached {JSON_NUMBER} new_state.item ("category") as new_category then
				category := new_category.item.to_integer_64
			end
		end

feature -- Change

end
