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
		local
			left: WSF_MULTI_CONTROL[WSF_STATELESS_CONTROL]
			right: WSF_MULTI_CONTROL[WSF_STATELESS_CONTROL]
		do
			Precursor
			create left.make ("leftcol")
			create right.make ("rightcol")
			main_control.add_control (left, 8)
			main_control.add_control (right, 4)
			left.add_control (create {WSF_BASIC_CONTROL}.make_with_body ("h3", "", "Projects"))
			right.add_control (create {WSF_BASIC_CONTROL}.make_with_body ("h3", "", "Search"))
			create datasource.make_default (database)
			create search_query.make ("query","")
			search_query.add_class ("form-control")
			search_query.set_change_event (agent change_query)
			right.add_control (search_query)
			create grid.make ("name",datasource)
			left.add_control (grid)
			navbar.set_active (2)
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

end
