note
	description: "Summary description for {SQL_CONDITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SQL_CONDITION

inherit

	Any
		redefine
			out
		end

feature

	query: STRING
	deferred
	end

	out: STRING
		do
			Result := "("
			Result.append (query)
			Result.append (")")
		end

	args: ARRAYED_LIST[ANY]
		deferred
		end

feature --helpers


	merge (a: ARRAYED_LIST[ANY];b:ITERABLE [ANY]): ARRAYED_LIST[ANY]
		do

			Result := a
			across
				b as x
			loop
				Result.extend ( x.item)
			end
		end


end
