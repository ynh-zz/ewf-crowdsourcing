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
			project_query.set_fields (<<["title"], ["description", "projects.description"], ["start"], ["end"], ["username"], ["user_description", "users.description"], ["avatar", "email"], ["funding", "(SELECT sum(amount) FROM fundings WHERE project_id = projects.id)"], ["backers", "(SELECT COUNT( DISTINCT user_id ) FROM fundings WHERE project_id = projects.id)"], ["next_goal", "(SELECT amount FROM goals WHERE project_id = goals.project_id and amount>(SELECT sum(amount) FROM fundings WHERE project_id = projects.id) limit 0,1)"]>>)
			project_query.set_where ("projects.id = " + project_id.out)
			project_query.left_join ("users", "users.id = user_id")
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
			description: STRING
		do
			Precursor
			main_control.add_column (8)
			main_control.add_column (4)
			navbar.set_active (2)
			create slider.make
			if attached project as a_project then
				main_control.add_control (1, create {WSF_BASIC_CONTROL}.make_with_body ("h1", "", a_project.get_string ("title")))
				main_control.add_control (1, slider)
				description := a_project.get_string ("description")
				description.replace_substring_all ("%N", "<br />")
				main_control.add_control (1, create {WSF_BASIC_CONTROL}.make_with_body ("p", "", description))
			end
			if attached media as a_media then
				across
					a_media as m
				loop
					slider.add_image (m.item.get_string ("url"), "")
				end
			end
				--Build Info box
			initialize_infobox
			initialize_userbox
				--Build Goals
			main_control.add_control (2, create {WSF_BASIC_CONTROL}.make_with_body ("h3", "", "Goals"))
			create goals_datasource.make_default (database, project_id)
			create goals.make (goals_datasource)
			main_control.add_control (2, goals)
				--Build Rewards
			main_control.add_control (2, create {WSF_BASIC_CONTROL}.make_with_body ("h3", "", "Rewards"))
			create rewards_datasource.make_default (database, project_id)
			create rewards.make (rewards_datasource)
			main_control.add_control (2, rewards)
		end

	initialize_infobox
		local
			body: STRING
			end_date: DATE_TIME
			duration: DATE_TIME_DURATION
			days: INTEGER_64
		do
			create body.make_empty
			if attached project as a_project then
				body.append (render_tag_with_tagname ("h1", a_project.get_integer ("backers").out, "style=%"margin-top:0;%"", ""))
				body.append (render_tag_with_tagname ("h5", "backers", "", ""))
				body.append (render_tag_with_tagname ("h1", "$" + a_project.get_real ("funding").out, "", ""))
				body.append (render_tag_with_tagname ("h5", "pledged of  $" + a_project.get_integer ("next_goal").out + " goal", "", ""))
				create end_date.make_from_string (a_project.get_string ("end"), "yyyy-[0]mm-[0]dd hh:[0]mi:[0]ss")
				duration := end_date.relative_duration (create {DATE_TIME}.make_now_utc)
				days := (duration.fine_seconds_count / 60 / 60 / 24).floor
				body.append (render_tag_with_tagname ("h1", "" + days.out, "", ""))
				body.append (render_tag_with_tagname ("h5", "days to go", "", ""))
				main_control.add_control (2, create {WSF_BASIC_CONTROL}.make_with_body ("div", "class=%"well%"", body))
			end
		end

	initialize_userbox
		local
			box: STRING
			body: STRING
		do
			if attached project as a_project then
				create box.make_empty
				box.append (render_tag_with_tagname ("a", render_tag_with_tagname ("img", "", "style=%"max-width: 200px;%" src=%"http://www.gravatar.com/avatar/" + a_project.get_string ("avatar") + "?d=identicon&f=y%"", "media-object"), "href=%"#%"", "pull-left thumbnail"))
				create body.make_empty
				body.append (render_tag_with_tagname ("h3", a_project.get_string ("username"), "", "media-heading"))
				body.append (a_project.get_string ("user_description"))
				box.append (render_tag_with_tagname ("div", body, "", "media-body"))
				main_control.add_control (2, create {WSF_BASIC_CONTROL}.make_with_body ("div", "class=%"media%"", box))
			end
		end

feature -- Implementation

	process
		do
		end

feature -- Properties

	goals: GOALS_REPEATER

	goals_datasource: GOALS_DATASOURCE

	rewards: REWARDS_REPEATER

	rewards_datasource: REWARDS_DATASOURCE

	project: detachable SQL_ENTITY

	media: detachable LIST [SQL_ENTITY]

	slider: WSF_SLIDER_CONTROL

	project_id: INTEGER_64

end
