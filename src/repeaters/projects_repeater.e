note
	description: "Summary description for {PROJECTS_REPEATER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROJECTS_REPEATER

inherit

	WSF_REPEATER_CONTROL [SQL_ENTITY]

create
	make

feature

	render_item (item: SQL_ENTITY): STRING
		local
			body: STRING
			progressbar:WSF_PROGRESS_CONTROL
		do
			create progressbar.make
			progressbar.set_progress ((item.get_real ("percentage").min (1)*100).floor)

			Result := ""
			Result.append (render_tag_with_tagname ("a", render_tag_with_tagname ("img", "", "style=%"max-width: 200px;%" src=%"" + item.get_string ("image") + "%"", "media-object"), "href=%"/project/" + item.get_integer ("id").out + "%"", "pull-left thumbnail"))
			body := ""
			body.append (render_tag_with_tagname ("a", render_tag_with_tagname ("h3", item.get_string ("title"), "", "media-heading"), "href=%"/project/" + item.get_integer ("id").out + "%"", ""))
			body.append (item.get_string ("description"))
			body.append (progressbar.render)
			Result.append (render_tag_with_tagname ("div", body, "", "media-body"))
			Result := render_tag_with_tagname ("div", Result, "", "media") + "<hr />"
		end

end
