note
	description: "Summary description for {CREATE_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CREATE_PAGE

inherit

	BASE_PAGE
		redefine
			initialize_controls
		end

create
	make

feature {NONE} -- Initialization

	initialize_controls
		local
			name: WSF_INPUT_CONTROL
			from_date: WSF_DATE_PICKER_CONTROL
			to_date: WSF_DATE_PICKER_CONTROL
			country: WSF_AUTOCOMPLETE_CONTROL
			city: WSF_INPUT_CONTROL
			category: WSF_INPUT_CONTROL
			funding_goal: WSF_INPUT_CONTROL
			short_description: WSF_INPUT_CONTROL
			description: WSF_TEXTAREA_CONTROL
			thumbnail: WSF_INPUT_CONTROL
			button: WSF_BUTTON_CONTROL
		do
			Precursor
			navbar.set_active (3)
			main_control.add_column (2)
			main_control.add_column (8)
			main_control.add_column (2)
			create form.make_with_label_width (3)
			main_control.add_control (2, form)
			create name.make ("")
			create name_container.make ("Project name", name)
			name_container.add_validator (create {WSF_AGENT_VALIDATOR [STRING]}.make (agent check_name, "Enter a valid projectname (between 3 and 50 characters)"))
			form.add_control (name_container)
			create from_date.make ("div")
			create from_date_container.make_without_border ("From", from_date)
			form.add_control (from_date_container)
			create to_date.make ("div")
			create to_date_container.make_without_border ("To", to_date)
			form.add_control (to_date_container)
			create country.make (create {FLAG_AUTOCOMPLETION}.make)
			create country_container.make ("Country", country)
			country_container.add_validator (create {WSF_AGENT_VALIDATOR [STRING]}.make (agent check_country, "Enter a valid country!"))
			form.add_control (country_container)
			create city.make ("")
			create city_container.make ("City", city)
			city_container.add_validator (create {WSF_AGENT_VALIDATOR [STRING]}.make (agent check_city, "Enter a valid city!"))
			form.add_control (city_container)
			create funding_goal.make ("")
			create funding_goal_container.make ("Funding goal", funding_goal)
			funding_goal_container.add_validator (create {WSF_DECIMAL_VALIDATOR}.make ("Enter a valid funding goal"))
			form.add_control (funding_goal_container)
			create category.make ("")
			create category_container.make ("Category", category)
			category_container.add_validator (create {WSF_AGENT_VALIDATOR [STRING]}.make (agent check_category, "Enter a valid category!"))
			form.add_control (category_container)
			create short_description.make ("")
			create short_description_container.make ("Short description", short_description)
			short_description_container.add_validator (create {WSF_AGENT_VALIDATOR [STRING]}.make (agent check_short_description, "Enter a valid short description!"))
			form.add_control (short_description_container)
			create description.make ("")
			create description_container.make ("Description", description)
			description_container.add_validator (create {WSF_AGENT_VALIDATOR [STRING]}.make (agent check_description, "Enter a valid description!"))
			form.add_control (description_container)
			create thumbnail.make ("")
			thumbnail.set_type ("url")
			thumbnail.append_attribute ("placeholder=%"optional%"")
			create thumbnail_container.make ("Thumbnail URL", thumbnail)
			thumbnail_container.add_validator (create {WSF_AGENT_VALIDATOR [STRING]}.make (agent check_thumbnail, "Enter a valid thumbnail!"))
			form.add_control (thumbnail_container)
			create button.make ("CREATE PROJECT")
			button.add_class ("btn-success btn-block")
			button.set_click_event (agent handle_click)
			form.add_control (button)
		end

feature -- Events

	handle_click
		local
			entity: SQL_ENTITY
			category_id: INTEGER
			user_id:INTEGER
			city_id:INTEGER
			timestamp: DATE_TIME
		do
			form.validate
			if form.is_valid then
				create entity.make
				create timestamp.make_now
				entity ["title"] := name_container.value_control.value
				entity ["category_id"] := category_id
				entity ["user_id"] := user_id
				entity ["city_id"] := city_id
				entity ["description"] := description_container.value_control.value
				entity ["start"] := from_date_container.value_control.value
				entity ["end"] := to_date_container.value_control.value
				entity ["updatetime"] := timestamp.formatted_out ("[0]dd-[0]mm-yyyy")
				entity.save (database, "projects")
			end
		end

feature -- Validations

	check_name (input: STRING): BOOLEAN
		do
			Result := input.count >= 3 and input.count <= 50
		end

	check_country (input: STRING): BOOLEAN
		do
			Result := True
		end

	check_city (input: STRING): BOOLEAN
		do
			Result := not input.is_empty
		end

	check_category (input: STRING): BOOLEAN
		do
			Result := not input.is_empty
		end

	check_short_description (input: STRING): BOOLEAN
		do
			Result := not input.is_empty
		end

	check_description (input: STRING): BOOLEAN
		do
			Result := not input.is_empty
		end

	check_thumbnail (input: STRING): BOOLEAN
		do
			Result := True
		end

feature -- Implementation

	process
		do
		end

feature -- Properties

	form: WSF_FORM_CONTROL

	name_container: WSF_FORM_ELEMENT_CONTROL [STRING]

	from_date_container: WSF_FORM_ELEMENT_CONTROL [STRING]

	to_date_container: WSF_FORM_ELEMENT_CONTROL [STRING]

	country_container: WSF_FORM_ELEMENT_CONTROL [STRING]

	city_container: WSF_FORM_ELEMENT_CONTROL [STRING]

	category_container: WSF_FORM_ELEMENT_CONTROL [STRING]

	funding_goal_container: WSF_FORM_ELEMENT_CONTROL [STRING]

	short_description_container: WSF_FORM_ELEMENT_CONTROL [STRING]

	description_container: WSF_FORM_ELEMENT_CONTROL [STRING]

	thumbnail_container: WSF_FORM_ELEMENT_CONTROL [STRING]

end
