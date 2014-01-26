note
	description: "Summary description for {IMAGE_INPUT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IMAGE_INPUT

inherit

	WSF_MULTI_CONTROL [WSF_STATELESS_CONTROL]
		rename
			make as make_multicontrol
		end

create
	make

feature {NONE}

	make (a_parent: IMAGE_INPUT_REPEATER)
		local
			button: WSF_BUTTON_CONTROL
		do
			parent := a_parent

			make_with_tag_name ("div")
			create button.make ("Remove this image")
			button.set_click_event (agent remove)
			button.add_class ("pull-right")
			button.add_class ("btn-xs")
			button.add_class ("btn-danger")
			add_control (button)

			add_control (create {WSF_BASIC_CONTROL}.make_with_body ("h4", "", "Image"))
			create form.make_with_label_width (3)
			create image_container.make ("Title", create {WSF_FILE_CONTROL}.make_with_image_preview)
			form.add_control (image_container)

			create description_container.make ("Description", create {WSF_TEXTAREA_CONTROL}.make (""))
			form.add_control (description_container)


			add_control (form)
			add_control (create {WSF_BASIC_CONTROL}.make_with_body ("hr", "", ""))
		end
feature -- Validations

	check_name (input: STRING): BOOLEAN
		do
			Result := input.count >= 3 and input.count <= 50
		end

feature -- Events

	remove
	do
		parent.remove_control_by_id (control_id)
	end

feature {NONE}
	parent: IMAGE_INPUT_REPEATER
	form: WSF_FORM_CONTROL

	image_container: WSF_FORM_ELEMENT_CONTROL [detachable WSF_FILE]
	description_container: WSF_FORM_ELEMENT_CONTROL [STRING]

end
