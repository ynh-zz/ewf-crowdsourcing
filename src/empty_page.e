note
	description: "Summary description for {EMPTY_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EMPTY_PAGE

inherit

	BASE_PAGE
		redefine
			initialize_controls
		end

create
	make

feature -- Initialization

	initialize_controls
		do
			Precursor
			navbar.set_active (1)
		end

feature -- Implementation

	process
		do
		end

end
