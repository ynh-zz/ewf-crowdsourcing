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

	initialize_controls
		do
			create control.make
			control.add_class ("container")
			create navbar.make_with_brand ("EWF Crowd Sourcing")
			navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/%"", "Home"))
			navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/projects%"", "Project grid"))
			navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/create%"", "Create new project"))
			if is_logged_in then
				initialize_user_profile
			else
				navbar.add_list_element (create {WSF_BASIC_CONTROL}.make_with_body ("a", "href=%"/signup%"", "Sign Up"))
				initialize_login_form
			end
			if not attached get_parameter ("ajax") then
				control.add_control (navbar)
			end
			create main_control.make ("main_control")
			control.add_control (main_control)
		end

	initialize_user_profile
		local
			dropdown: WSF_DROPDOWN_CONTROL
			username: STRING
		do
			if attached current_user as a_current_user then
				username := render_tag_with_tagname ("img", "", "style=%"max-width: 20px;margin-right: 10px;%" src=%"http://www.gravatar.com/avatar/" + a_current_user.get_string ("avatar") + "?d=identicon&f=y%"", "")
				username.append (a_current_user.get_string ("username"))
				create dropdown.make_with_tag_name (username, "li")
				dropdown.add_link_item ("My Profile", "/me")
				dropdown.add_divider
				dropdown.add_link_item ("Logout", "/logout")
				navbar.add_element_right (dropdown)
			end
		end

	initialize_login_form
		local
			dropdown: WSF_DROPDOWN_CONTROL
			button: WSF_BUTTON_CONTROL
			username: WSF_INPUT_CONTROL
			password: WSF_PASSWORD_CONTROL
			a_username_container: WSF_FORM_ELEMENT_CONTROL [STRING]
			a_password_container: WSF_FORM_ELEMENT_CONTROL [STRING]
			a_login_form: detachable WSF_FORM_CONTROL
		do
				-- create login form elements
			create username.make ("")
			username.append_attribute ("placeholder=%"username%"")
			create password.make ("")
			password.append_attribute ("placeholder=%"password%"")
			create a_username_container.make (Void, username)
			a_username_container.add_validator (create {WSF_AGENT_VALIDATOR [STRING]}.make (agent validate_username, "Username does not exist!"))
			username_container := a_username_container
			create a_password_container.make (Void, password)
			a_password_container.add_validator (create {WSF_AGENT_VALIDATOR [STRING]}.make (agent validate_password, "Wrong password!"))
			password_container := a_password_container
				-- create login form
			create a_login_form.make
			create button.make ("Sign In")
			button.set_click_event (agent handle_login_click)
			button.add_class ("btn-primary btn-block")
			a_login_form.add_control (a_username_container)
			a_login_form.add_control (a_password_container)
			a_login_form.add_control (button)
			login_form := a_login_form
				-- create dropdown
			create dropdown.make_with_tag_name ("Sign In", "li")
			dropdown.add_item (a_login_form)
			dropdown.dropdown_menu.append_attribute ("style=%"min-width: 250px; padding: 15px; padding-bottom: 0px%"")
			navbar.add_element_right (dropdown)
		end

feature -- Event

	handle_login_click
		local
			query: SQL_QUERY [SQL_ENTITY]
			condition: SQL_CONDITIONS
		do
			if attached login_form as a_login_form and attached username_container as a_username_container then
				a_login_form.validate
				if a_login_form.is_valid then
					create query.make ("users")
					query.set_fields (<<["id"], ["username"]>>)
					create condition.make_condition ("AND")
					condition ["username"].equals (a_username_container.value)
					query.set_where (condition)
					login (query.first (database))
				end
			end
		end

feature {NONE} -- Validations

	validate_username (n: STRING): BOOLEAN
		local
			users_query: SQL_QUERY [SQL_ENTITY]
			condition: SQL_CONDITIONS
		do
			create users_query.make ("users")
			users_query.set_fields (<<["username"]>>)
			create condition.make_condition ("AND")
			condition ["username"].equals (n)
			users_query.set_where (condition)
			Result := users_query.count_total (database) = 1
		end

	validate_password (p: STRING): BOOLEAN
		local
			users_query: SQL_QUERY [SQL_ENTITY]
			condition: SQL_CONDITIONS
		do
			if attached username_container as a_username_container then
				create users_query.make ("users")
				users_query.set_fields (<<["username"]>>)
				create condition.make_condition ("AND")
				condition ["password"].equals (p)
				condition ["username"].equals (a_username_container.value)
				users_query.set_where (condition)
				Result := users_query.count_total (database) = 1
			end
		end

feature {NONE} --User

	user_loaded: BOOLEAN

	current_user_cached: detachable SQL_ENTITY

feature -- User session

	current_user: detachable SQL_ENTITY
		local
			users_query: SQL_QUERY [SQL_ENTITY]
			condition: SQL_CONDITIONS
		do
			if not user_loaded then
				if attached request.cookie ("user") as id then
					create users_query.make ("users")
					users_query.set_fields (<<["id"], ["username"], ["description"], ["avatar", "email"], ["email"]>>)
					create condition.make_condition ("AND")
					condition ["id"].equals (id.string_representation)
					users_query.set_where (condition)
					current_user_cached := users_query.first (database)
				end
				user_loaded := true
			end
			Result := current_user_cached
		end

	login (user: detachable SQL_ENTITY)
		require
			attached user as a_user and then attached a_user ["id"]
		local
			h: HTTP_HEADER
			date: DATE_TIME
		do
			if attached user as a_user and then attached a_user ["id"] as id then
				create h.make
				create date.make_now
				date.add (create {DATE_TIME_DURATION}.make (0, 1, 0, 0, 0, 0))
				h.put_cookie ("user", id.out, Void, "/", Void, False, False)
				response.put_header_lines (h)
				redirect ("/")
			end
		end

	is_logged_in: BOOLEAN
		do
			Result := attached current_user
		end

feature -- Properties

	database: SQLITE_DATABASE

	main_control: WSF_LAYOUT_CONTROL

	control: WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]

	navbar: WSF_NAVBAR_CONTROL

feature {NONE} --Local controls

	username_container: detachable WSF_FORM_ELEMENT_CONTROL [STRING]

	password_container: detachable WSF_FORM_ELEMENT_CONTROL [STRING]

	login_form: detachable WSF_FORM_CONTROL

end
