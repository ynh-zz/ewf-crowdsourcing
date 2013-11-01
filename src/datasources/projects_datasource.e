note
	description: "Summary description for {PROJECTS_DATASOURCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PROJECTS_DATASOURCE

inherit

	SQL_DATASOURCE [SQL_ENTITY]

create
	make_default

feature

	make_default (db: SQLITE_DATABASE)
		do
		make(db, "projects", <<["id"],["title"],["description"]>>)
		end


end
