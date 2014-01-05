 note
	description: "Summary description for {PROJECTS_REPEATER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GOALS_REPEATER

inherit

	WSF_REPEATER_CONTROL [SQL_ENTITY]

create
	make

feature

	render_item (item: SQL_ENTITY): STRING
		local
			body: STRING
			progressbar: WSF_PROGRESS_CONTROL
		do
			create progressbar.make
			progressbar.set_progress ((item.get_real ("percentage").min (1) * 100).floor)
			Result := ""
			body := ""
			body.append (render_tag_with_tagname ("h4", item.get_string ("title"), "", "media-heading"))
			body.append (render_tag_with_tagname ("p", render_tag_with_tagname ("span", item.get_integer ("amount").out + "$", "", "label label-success"), "", ""))
			body.append (render_tag_with_tagname ("p", item.get_string ("description"), "", ""))
			body.append (progressbar.render)
			Result := render_tag_with_tagname ("div", body, "", "") + "<hr />"
		end

end
