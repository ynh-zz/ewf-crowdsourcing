note
	description: "Summary description for {GRID_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GRID_PAGE

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
			main_control.add_control (1, create {WSF_BASIC_CONTROL}.make_with_body ("h3", "", "Projects"))
			main_control.add_control (2, create {WSF_BASIC_CONTROL}.make_with_body ("h3", "", "Search"))
			create datasource.make_default (database)
			create search_query.make ("")
			search_query.add_class ("form-control")
			search_query.set_change_event (agent change_query)
			main_control.add_control (2, search_query)
			main_control.add_control (2, create {WSF_BASIC_CONTROL}.make_with_body ("h4", "", "Category"))
			create category_list.make
			category_list.add_button (agent choose_category(1), "Any")
			category_list.add_button (agent choose_category(2), "Technology")
			category_list.add_button (agent choose_category(3), "Software")
			category_list.add_button (agent choose_category(4), "Art")
			main_control.add_control (2, category_list)
			main_control.add_control (2, create {WSF_BASIC_CONTROL}.make_with_body ("h4", "", "Country"))
			create navlist.make
			navlist.add_button (agent choose_country(1), "Switzerland")
			navlist.add_button (agent choose_country(2), "Germany")
			navlist.add_button (agent choose_country(3), "France")
			main_control.add_control (2, navlist)
			create grid.make (datasource)
			main_control.add_control (1, grid)
			navbar.set_active (2)
		end

	choose_country (i: INTEGER)
		do
			across
				navlist.controls as it
			loop
				it.item.set_active (it.cursor_index = i)
			end
		end

	choose_category (i: INTEGER)
		do
			across
				category_list.controls as it
			loop
				it.item.set_active (it.cursor_index = i)
			end
		end

	change_query
		do
			datasource.set_query (search_query.value)
			datasource.set_page (1)
			datasource.update
		end

	process
		do
		end

	grid: PROJECTS_REPEATER

	search_query: WSF_INPUT_CONTROL

	datasource: PROJECTS_DATASOURCE

	navlist: WSF_NAVLIST_CONTROL

	category_list: WSF_NAVLIST_CONTROL

end
