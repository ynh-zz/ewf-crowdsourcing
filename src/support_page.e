note
	description: "Summary description for {SIGNUP_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SUPPORT_PAGE

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
			amount: WSF_INPUT_CONTROL
		do
			Precursor
			navbar.set_active (2)
			main_control.add_column (3)
			main_control.add_column (6)
			main_control.add_column (3)
			main_control.add_control (2, create {WSF_BASIC_CONTROL}.make_with_body ("h1", "", "Support project"))
			create form.make
			create amount.make ("")
			create amount_container.make ("Amount", amount)
			form.add_control (amount_container)
			main_control.add_control (2, form)
		end

	handle_click
		do
			form.validate
			if form.is_valid then

			end
		end

feature -- Implementation

	process
		do
		end

feature -- Properties

	amount_container: WSF_FORM_ELEMENT_CONTROL[STRING]

	form: WSF_FORM_CONTROL

end
