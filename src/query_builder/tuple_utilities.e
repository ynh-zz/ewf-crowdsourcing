note
	description: "[
		Helper routines for tuple {TUPLE_UTILITIES}.
	]"
	date: "$Date$"
	revision: "$Revision$"

expanded class
	TUPLE_UTILITIES

inherit

	ANY

	REFLECTOR
		export
			{NONE} all
		end

feature -- Access

	concatenation (a_tuple_1, a_tuple_2: TUPLE): TUPLE
			-- Concatenation of `a_tuple_1' with `a_tuple_2'
			--| note: it may be Void if the result has more than the allowed capacity for a tuple.
		local
			i, n1, n2: INTEGER
			t1, t2: TYPE [detachable TUPLE]
			l_type_id: INTEGER
			l_items: ARRAYED_LIST [detachable ANY]
			l_type_string: STRING
		do
			if a_tuple_1.count = 0 then
				Result := a_tuple_2.twin
			elseif a_tuple_2.count = 0 then
				Result := a_tuple_1.twin
			else
				create l_type_string.make_from_string ("TUPLE [")
				n1 := a_tuple_1.count
				n2 := a_tuple_2.count
				create l_items.make (n1 + n2)
				from
					t1 := a_tuple_1.generating_type
					check
						same_count: t1.generic_parameter_count = n1
					end
					i := 1
				until
					i > n1
				loop
					if i > 1 then
						l_type_string.append_character (',')
					end
					l_type_string.append (t1.generic_parameter_type (i).name)
					l_items.extend (a_tuple_1.item (i))
					i := i + 1
				end
				from
					t2 := a_tuple_2.generating_type
					check
						same_count: t2.generic_parameter_count = n2
					end
				until
					i > n1 + n2
				loop
					l_type_string.append_character (',')
					l_type_string.append (t2.generic_parameter_type (i - n1).name)
					l_items.extend (a_tuple_2.item (i - n1))
					i := i + 1
				end
				l_type_string.append_character (']')
				l_type_id := dynamic_type_from_string (l_type_string)
				Result := []
				if attached {TUPLE} new_instance_of (l_type_id) as tpl then
					across
						l_items as x
					loop
						tpl [x.cursor_index] := x.item
					end
					Result := tpl
				end
			end
		end

end
