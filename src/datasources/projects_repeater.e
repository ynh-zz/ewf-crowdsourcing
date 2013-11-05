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
		do
			Result := ""
			if attached {STRING}item["image"] as image then
				Result.append (render_tag_with_tagname ("a", render_tag_with_tagname ("img", "", "style=%"max-width: 200px;%" src=%"" + image + "%"", "media-object"), "href=%"#%"", "pull-left thumbnail"))
			end
			body := ""
			if attached {STRING}item["title"] as title then
				body.append (render_tag_with_tagname ("h3", title, "", "media-heading"))
			end
			if attached {STRING}item["description"] as description then
				body.append (description)
			end
			Result.append (render_tag_with_tagname ("div", body, "", "media-body"))
			Result := render_tag_with_tagname ("div", Result, "", "media") + "<hr />"
		end

end
