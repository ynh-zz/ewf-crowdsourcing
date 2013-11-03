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
		local
			a_query: SQL_QUERY
			cond: SQL_CONDITIONS
		do
			create a_query.make
			create cond.make_condition ("AND")
			cond.contains ("title", "g")
			a_query.set_fields (<<["id"], ["title"], ["description"]>>)
			a_query.set_table_name ("projects")
			a_query.set_where (cond)
			make (db, a_query)
		end

end
