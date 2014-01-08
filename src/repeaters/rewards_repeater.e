note
	description: "Summary description for {REWARDS_REPEATER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REWARDS_REPEATER

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
			body := ""
			body.append (render_tag_with_tagname("a", render_tag_with_tagname ("h4", "Pledge $" + item.get_real ("amount").out + " or more", "", ""), "href=%"#%"", ""))
			body.append (render_tag_with_tagname ("p", render_tag_with_tagname ("span", item.get_integer ("taken").out + " of " + item.get_integer ("availability").out + " taken", "", "label label-default"), "", ""))
			body.append (render_tag_with_tagname ("p", item.get_string ("description"), "", ""))
			Result := render_tag_with_tagname ("div", body, "", "") + "<hr />"
		end

end
