--スカイＧ３
function c100000445.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100000445.target)
	e1:SetOperation(c100000445.activate)
	c:RegisterEffect(e1)
end
function c100000445.cfilter(c,e,tp)
	return c:IsAbleToGraveAsCost() and (c:IsCode(100000058) or c:IsCode(100000045) or c:IsCode(100000043))
		and Duel.IsExistingMatchingCard(c100000445.spfilter,tp,0x13,0,1,nil,e,tp)
end
function c100000445.spfilter(c,e,tp)
	return c:IsCode(100000045) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100000445.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.IsExistingMatchingCard(c100000445.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100000445.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c100000445.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100000445.spfilter,tp,0x13,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end