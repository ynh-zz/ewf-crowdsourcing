note
	description: "Summary description for {GOALS_DATASOURCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GOALS_DATASOURCE

inherit

	SQL_DATASOURCE [SQL_ENTITY]

create
	make_default

feature {NONE}

	make_default (db: SQLITE_DATABASE; a_project_id: INTEGER_64)
		do
			make (db)
			project_id := a_project_id
		end

feature

	build_query
		local
			cond: SQL_CONDITIONS
			a_query: SQL_QUERY [SQL_ENTITY]
		do
			-- Select the table goals
			create a_query.make ("goals")
			a_query.set_fields (<<["title"],["amount"],["description"],["percentage","(SELECT sum(amount) FROM fundings WHERE project_id = goals.project_id)/amount"]>>)
 			-- Filter goals by project id
 			create cond.make_condition ("AND")
			a_query.set_where (cond)
			cond ["project_id"].equals (project_id)
			-- Order goals by ammount
			a_query.set_order_by ("amount asc")
			query := a_query
		end

	project_id: INTEGER_64

end
