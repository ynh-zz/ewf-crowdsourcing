note
	description: "Summary description for {BASE_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BASE_PAGE

inherit

	WSF_PAGE_CONTROL
		rename
			make as make_wsf_page
		redefine
			control
		end

feature {NONE}

	make (db: SQLITE_DATABASE; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			database := db
			make_wsf_page (req, res)
		end

feature

	initialize_controls
		local
			btn: WSF_BUTTON_CONTROL
		do
			create control.make
			control.add_class ("container")
			create navbar.make_with_brand ("EWF Crowd Sourcing")
			navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/%"", "Home"))
			navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/projects%"", "Project grid"))
			if not attached get_parameter ("ajax") then
				control.add_control (navbar)
			end
			create main_control.make ("main_control")
			control.add_control (main_control)
		end

feature
	main_control: WSF_LAYOUT_CONTROL
	control: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]

feature --DB

	database: SQLITE_DATABASE
	navbar: WSF_NAVBAR_CONTROL

end
