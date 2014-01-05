note
	description: "[
		Helper routines for tuple {TUPLE_UTILITIES}.
	]"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	LIST_UTILITIES

inherit

	ANY

feature -- Access

	concatenation (a, b: ARRAYED_LIST [detachable ANY]): ARRAYED_LIST [detachable ANY]
		do
			create Result.make (a.count + b.count)
			Result.append (a)
			Result.append (b)
		end

end
