note
	description: "Summary description for {DETAIL_PAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DETAIL_PAGE

inherit

	BASE_PAGE
		redefine
			initialize_controls,
			make
		end

create
	make

feature {NONE}

	make (db: SQLITE_DATABASE; req: WSF_REQUEST; res: WSF_RESPONSE)
		do
			database := db
			if attached req.path_parameter ("project_id") as a_id then
				project_id := a_id.as_string.value.to_integer_64
			end
			load_data
			make_wsf_page (req, res)
		end

	load_data
		local
			project_query: SQL_QUERY [SQL_ENTITY]
			media_query: SQL_QUERY [SQL_ENTITY]
		do
			create project_query.make ("projects")
			project_query.set_fields (<<["title"], ["description"], ["funding", "(SELECT sum(amount) FROM fundings WHERE project_id = projects.id)"], ["backers", "(SELECT COUNT( DISTINCT user_id ) FROM fundings WHERE project_id = projects.id)"], ["next_goal", "(SELECT amount FROM goals WHERE project_id = goals.project_id and amount>(SELECT sum(amount) FROM fundings WHERE project_id = projects.id) limit 0,1)"]>>)
			project_query.set_where ("id = " + project_id.out)
			project := project_query.first (database)

				--Load Media
			create media_query.make ("media")
			media_query.set_fields (<<["tag"], ["url"]>>)
			media_query.set_where ("project_id = " + project_id.out + " and tag != 'thumbnail' ")
			media := media_query.run (database)
		end

feature -- Initialization

	initialize_controls
	local
		description:STRING
		do
			Precursor
			main_control.add_column (8)
			main_control.add_column (4)
			navbar.set_active (2)
			create slider.make
			if attached project as a_project then
				main_control.add_control (1, create {WSF_BASIC_CONTROL}.make_with_body ("h1", "", a_project.get_string ("title")))
				main_control.add_control (1, slider)
				description:= a_project.get_string ("description")
				description.replace_substring_all ("%N", "<br />")
				main_control.add_control (1, create {WSF_BASIC_CONTROL}.make_with_body ("p", "",description))
			end
			if attached media as a_media then
				across
					a_media as m
				loop
					slider.add_image (m.item.get_string ("url"), "")
				end
			end
			main_control.add_control (2, create {WSF_BASIC_CONTROL}.make_with_body ("h3", "", "Goals"))
			create goals_datasource.make_default (database, project_id)
			create goals.make (goals_datasource)
			main_control.add_control (2, goals)
			initialize_infobox
		end

	initialize_infobox
		local
			body: STRING
		do
			create body.make_empty
			if attached project as a_project then
				body.append (render_tag_with_tagname ("h1", a_project.get_integer ("backers").out, "style=%"margin-top:0;%"", ""))
				body.append (render_tag_with_tagname ("h5", "backers", "", ""))
				body.append (render_tag_with_tagname ("h1", "$"+a_project.get_real ("funding").out, "", ""))
				body.append (render_tag_with_tagname ("h5", "pledged of  $"+a_project.get_integer ("next_goal").out+" goal", "", ""))
				main_control.add_control (2, create {WSF_BASIC_CONTROL}.make_with_body ("div", "class=%"well%"", body))
			end
		end

feature -- Implementation

	process
		do
		end

feature -- Properties

	goals: GOALS_REPEATER

	goals_datasource: GOALS_DATASOURCE

	project: detachable SQL_ENTITY

	media: detachable LIST [SQL_ENTITY]

	slider: WSF_SLIDER_CONTROL

	project_id: INTEGER_64

end
