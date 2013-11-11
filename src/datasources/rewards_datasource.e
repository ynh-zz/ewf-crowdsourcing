note
	description: "Summary description for {REWARDS_DATASOURCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	REWARDS_DATASOURCE


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

			create a_query.make ("rewards")
			a_query.set_fields (<<["amount"],["description"],["availability"],["taken","(SELECT count(*) FROM fundings WHERE reward_id = rewards.id)"]>>)
 			create cond.make_condition ("AND")
			a_query.set_where (cond)
			cond ["project_id"].equals (project_id)
			a_query.set_order_by ("amount asc")
			query := a_query
		end
feature -- Additional state information
	project_id: INTEGER_64

end

