--Ｓｐ－大地讃頌
function c100101002.initial_effect(c)
	aux.AddRitualProcEqual(c,c100101002.ritual_filter)
end
function c100101002.ritual_filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAttribute(ATTRIBUTE_EARTH)
	 and Duel.GetFieldCard(Duel.GetTurnPlayer(),LOCATION_SZONE,5):GetCounter(0x91)>1
end
