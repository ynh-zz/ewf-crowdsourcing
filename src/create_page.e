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
			from_date: WSF_DATETIME_PICKER_CONTROL
			to_date: WSF_DATETIME_PICKER_CONTROL
			country: WSF_AUTOCOMPLETE_CONTROL
			city: WSF_INPUT_CONTROL
			category: WSF_INPUT_CONTROL
			short_description: WSF_INPUT_CONTROL
			description: WSF_TEXTAREA_CONTROL
			thumbnail: WSF_INPUT_CONTROL
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
			form.add_control (name_container)
			create from_date.make ("div")
			create from_date_container.make ("From", from_date)
			form.add_control (from_date_container)
			create to_date.make ("div")
			create to_date_container.make ("To", to_date)
			form.add_control (to_date_container)
			create country.make (create {FLAG_AUTOCOMPLETION}.make)
			create country_container.make ("Country", country)
			form.add_control (country_container)
			create city.make ("")
			create city_container.make ("City", city)
			form.add_control (city_container)
			create category.make ("")
			create category_container.make ("Category", category)
			form.add_control (category_container)
			create short_description.make ("")
			create short_description_container.make ("Short description", short_description)
			form.add_control (short_description_container)
			create description.make ("")
			create description_container.make ("Description", description)
			form.add_control (description_container)
			create thumbnail.make ("")
			thumbnail.set_type ("url")
			create thumbnail_container.make ("Thumbnail URL", thumbnail)
			form.add_control (thumbnail_container)
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

	short_description_container: WSF_FORM_ELEMENT_CONTROL [STRING]

	description_container: WSF_FORM_ELEMENT_CONTROL [STRING]

	thumbnail_container: WSF_FORM_ELEMENT_CONTROL [STRING]

end
