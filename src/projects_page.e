note
	description: "Summary description for {GRID_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROJECTS_PAGE

inherit

	BASE_PAGE
		redefine
			initialize_controls
		end

create
	make

feature

	initialize_controls
		do
			Precursor
			main_control.add_column (8)
			main_control.add_column (4)
			navbar.set_active (2)
			build_grid
			build_sidebar
		end

	build_sidebar
		do
			main_control.add_control (2, create {WSF_BASIC_CONTROL}.make_with_body ("h3", "", "Search"))
			create search_query.make ("")
			search_query.add_class ("form-control")
			search_query.set_change_event (agent change_query)
			main_control.add_control (2, search_query)
			build_category_chooser
			build_city_chooser
		end

	build_category_chooser
		local
			categories: SQL_QUERY [SQL_ENTITY]
		do
			main_control.add_control (2, create {WSF_BASIC_CONTROL}.make_with_body ("h4", "", "Category"))
			create category_list.make
				--Load categories
			create categories.make ("categories")
			categories.set_fields (<<["id"], ["name"]>>)
			across
				categories.run (database) as c
			loop
				if attached c.item ["name"] as val and attached {INTEGER_64} c.item ["id"] as id then
					category_list.add_button (agent choose_category(c.cursor_index, id), val.out)
				end
			end
			main_control.add_control (2, category_list)
		end

	build_city_chooser
		local
			cities: SQL_QUERY [SQL_ENTITY]
		do
			main_control.add_control (2, create {WSF_BASIC_CONTROL}.make_with_body ("h4", "", "City"))
			create navlist.make
			navlist.add_button (agent choose_city(1, 0), "All")
				-- Cities
			create cities.make ("cities")
			cities.set_fields (<<["id"], ["name"]>>)
			across
				cities.run (database) as c
			loop
				if attached c.item ["name"] as name and attached {INTEGER_64} c.item ["id"] as id then
					navlist.add_button (agent choose_city(c.cursor_index + 1, id), name.out)
				end
			end
			main_control.add_control (2, navlist)
		end

	build_grid
		do
			create datasource.make_default (database)
			create grid.make (datasource)
			main_control.add_control (1, create {WSF_BASIC_CONTROL}.make_with_body ("h3", "", "Projects"))
			main_control.add_control (1, grid)
		end

	choose_city (i: INTEGER; id: INTEGER_64)
		do
			across
				navlist.controls as it
			loop
				it.item.set_active (it.cursor_index = i)
			end
			datasource.set_city (id)
			datasource.update
		end

	choose_category (i: INTEGER; id: INTEGER_64)
		do
			across
				category_list.controls as it
			loop
				it.item.set_active (it.cursor_index = i)
			end
			datasource.set_category (id)
			datasource.update
		end

	change_query
		do
			datasource.set_query (search_query.value)
			datasource.set_page (1)
			datasource.update
		end

	process
		do
			choose_category (1, 1)
			choose_city (1, 0)
		end

	grid: PROJECTS_REPEATER

	search_query: WSF_INPUT_CONTROL

	datasource: PROJECTS_DATASOURCE

	navlist: WSF_NAVLIST_CONTROL

	category_list: WSF_NAVLIST_CONTROL

end
