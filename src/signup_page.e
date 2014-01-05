note
	description: "Summary description for {SIGNUP_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SIGNUP_PAGE

inherit

	BASE_PAGE
		redefine
			initialize_controls
		end

create
	make

feature {NONE}

	initialize_controls
		local
			button1: WSF_BUTTON_CONTROL
		do
			Precursor
			navbar.set_active (4)
			main_control.add_column (3)
			main_control.add_column (6)
			main_control.add_column (3)
			main_control.add_control (2, create {WSF_BASIC_CONTROL}.make_with_body ("h1", "", "Signup"))
			create form.make_with_label_width (4)
			form.add_class ("form-horizontal")
			create name_container.make ("Username", create {WSF_INPUT_CONTROL}.make (""))
			name_container.add_validator (create {WSF_MIN_VALIDATOR [STRING]}.make (3, "Username must contain at least 3 characters"))
			name_container.add_validator (create {WSF_MAX_VALIDATOR [STRING]}.make (15, "Username can contain at most 15 characters"))
			name_container.add_validator (create {WSF_AGENT_VALIDATOR [STRING]}.make (agent check_username, "Username already taken"))
			form.add_control (name_container)
			create email_container.make ("Email", create {WSF_INPUT_CONTROL}.make (""))
			email_container.add_validator (create {WSF_EMAIL_VALIDATOR}.make ("Invalid email address"))
			form.add_control (email_container)
			create password2_container.make ("Password", create {WSF_PASSWORD_CONTROL}.make (""))
			password2_container.add_validator (create {WSF_MIN_VALIDATOR [STRING]}.make (6, "Password must contain at least 6 characters"))
			form.add_control (password2_container)
			create password3_container.make ("Repeat password", create {WSF_PASSWORD_CONTROL}.make (""))
			password3_container.add_validator (create {WSF_AGENT_VALIDATOR [STRING]}.make (agent compare_password, "Passwords do not match"))
			form.add_control (password3_container)
			main_control.add_control (2, form)
			create button1.make ("Register")
			button1.set_click_event (agent handle_click)
			button1.add_class (" btn-lg btn-primary btn-block")
			form.add_control (button1)
		end

	handle_click
		do
			form.validate
		end

	compare_password (input: STRING): BOOLEAN
		do
			Result := password2_container.value_control.value.same_string (input)
		end

	check_username (input: STRING): BOOLEAN
		local
			users_query: SQL_QUERY [SQL_ENTITY]
			condition: SQL_CONDITIONS
		do
			create users_query.make ("users")
			users_query.set_fields (<<["username"]>>)
			create condition.make_condition ("AND")
			condition ["username"].sql_like (input)
			users_query.set_where (condition)
			Result := users_query.count_total (database) = 0
		end

feature -- Implementation

	process
		do
		end

feature -- Properties

	form: WSF_FORM_CONTROL

	name_container: WSF_FORM_ELEMENT_CONTROL [STRING]

	email_container: WSF_FORM_ELEMENT_CONTROL [STRING]

	password2_container: WSF_FORM_ELEMENT_CONTROL [STRING]

	password3_container: WSF_FORM_ELEMENT_CONTROL [STRING]

end
