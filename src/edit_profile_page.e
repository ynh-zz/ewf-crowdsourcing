note
	description: "Summary description for {EDIT_PROFILE_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EDIT_PROFILE_PAGE

inherit

	BASE_PAGE
		redefine
			initialize_controls
		end

create
	make

feature {NONE}

	initialize_controls
		do
			Precursor
			navbar.set_active (4)
			main_control.add_column (3)
			main_control.add_column (6)
			main_control.add_column (3)
			create title.make_with_body ("h1", "", "Edit Profile")
			main_control.add_control (2, title)
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
			main_control.add_control (2, form)
			create submit_button.make ("Update Profile")
			submit_button.set_click_event (agent handle_click)
			submit_button.add_class (" btn-lg btn-primary btn-block")
			form.add_control (submit_button)
			if attached current_user as user then
				if attached user ["username"] as name then
					name_container.set_value (name.out)
				end
				if attached user ["email"] as email then
					email_container.set_value (email.out)
				end
			end
		end

	handle_click
		local
			city_id: INTEGER
		do
			form.validate
			if form.is_valid and attached current_user as user then
				user ["username"] := name_container.value
				user ["email"] := email_container.value
				user ["city_id"] := city_id
				user.save (database, "users")
				login (user)
			end
		end

	check_username (input: STRING): BOOLEAN
		local
			users_query: SQL_QUERY [SQL_ENTITY]
			condition: SQL_CONDITIONS
		do
			if attached current_user as a_user and then attached a_user ["id"] as id then
				create users_query.make ("users")
				users_query.set_fields (<<["username"]>>)
				create condition.make_condition ("AND")
				condition ["username"].equals (input)
				condition ["id"].not_equals (id)
				users_query.set_where (condition)
				Result := users_query.count_total (database) = 0
			end
		end

feature -- Implementation

	process
		do
		end

feature -- Properties

	form: WSF_FORM_CONTROL

	name_container: WSF_FORM_ELEMENT_CONTROL [STRING]

	email_container: WSF_FORM_ELEMENT_CONTROL [STRING]

	title: WSF_BASIC_CONTROL

	submit_button: WSF_BUTTON_CONTROL

end
