note
	description: "Summary description for {EDIT_PROFILE_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EDIT_PROFILE_PAGE

inherit

	SIGNUP_PAGE
		redefine
			initialize_controls,
			check_username
		end

create
	make

feature {NONE}

	initialize_controls
		local
			button1: WSF_BUTTON_CONTROL
		do
			Precursor
			title.set_body ("Edit Profile")
			submit_button.set_text ("Update Profile")
			if attached current_user as a_user then
				if attached a_user ["username"] as username then
					name_container.set_value (username.out)
				end
				if attached a_user ["email"] as email then
					email_container.set_value (email.out)
				end
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

end
