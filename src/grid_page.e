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
			control.add_control (create {WSF_BASIC_CONTROL}.make_with_body ("h1", "", "Grid Demo"))
			create datasource.make (database)
			create grid.make_grid ("mygrid", <<create {WSF_GRID_COLUMN}.make ("Title", "title"), create {WSF_GRID_COLUMN}.make ("Description", "description")>>, datasource)
			control.add_control (grid)
			navbar.set_active(2)
		end


	process
		do
		end

	grid: WSF_GRID_CONTROL [PROJECT_ENTITY]


	datasource: PROJECTS_DATASOURCE

end
