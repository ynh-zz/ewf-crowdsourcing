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
			dropdown: WSF_DROPDOWN_CONTROL
			button: WSF_BUTTON_CONTROL
		do
			create control.make
			control.add_class ("container")
			create navbar.make_with_brand ("EWF Crowd Sourcing")
			navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/%"", "Home"))
			navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/projects%"", "Project grid"))
			navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/signup%"", "Sign Up"))
				-- create login form elements
			create username.make ("")
			username.append_attribute ("placeholder=%"username%"")
			create password.make ("")
			password.append_attribute ("placeholder=%"password%"")
			create username_container.make (Void, username)
			username_container.add_validator (create {WSF_AGENT_VALIDATOR [STRING]}.make (agent validate_username, "Username does not exist!"))
			create password_container.make (Void, password)
			password_container.add_validator (create {WSF_AGENT_VALIDATOR [STRING]}.make (agent validate_password, "Wrong password!"))
				-- create login form
			create login_form.make
			create button.make ("Sign In")
			button.set_click_event (agent handle_login_click)
			button.add_class ("btn-primary btn-block")
			login_form.add_control (username_container)
			login_form.add_control (password_container)
			login_form.add_control (button)
				-- create dropdown
			create dropdown.make_with_tag_name ("Sign In", "li")
			dropdown.add_item (login_form)
			dropdown.dropdown_menu.append_attribute ("style=%"min-width: 250px; padding: 15px; padding-bottom: 0px%"")
			navbar.add_element_right (dropdown)
			if not attached get_parameter ("ajax") then
				control.add_control (navbar)
			end
			create main_control.make ("main_control")
			control.add_control (main_control)
		end

feature -- Event

	handle_login_click
		do
			login_form.validate
		end

feature -- Validations

	validate_username (n: STRING): BOOLEAN
		local
			users_query: SQL_QUERY [SQL_ENTITY]
			condition: SQL_CONDITIONS
		do
			create users_query.make ("users")
			users_query.set_fields (<<["username"]>>)
			create condition.make_condition ("AND")
			condition ["username"].sql_like (n)
			users_query.set_where (condition)
			Result := users_query.count_total (database) = 1
		end

	validate_password (p: STRING): BOOLEAN
		local
			users_query: SQL_QUERY [SQL_ENTITY]
			condition: SQL_CONDITIONS
		do
			create users_query.make ("users")
			users_query.set_fields (<<["password"]>>)
			create condition.make_condition ("AND")
			condition ["password"].sql_like (p)
			users_query.set_where (condition)
			Result := users_query.count_total (database) = 1
		end

feature -- Properties

	database: SQLITE_DATABASE

	main_control: WSF_LAYOUT_CONTROL

	control: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]

	navbar: WSF_NAVBAR_CONTROL

	username: WSF_INPUT_CONTROL

	username_container: WSF_FORM_ELEMENT_CONTROL [STRING]

	password: WSF_PASSWORD_CONTROL

	password_container: WSF_FORM_ELEMENT_CONTROL [STRING]

	login_form: WSF_FORM_CONTROL

end
