--Earthbound God Uru
function c511000242.initial_effect(c)
	c:SetUniqueOnField(1,1,10000000)
	--Cannot be Set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SET_PROC)
	e1:SetCondition(c511000242.setcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_TURN_SET)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Can Attack Directly
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	e3:SetCondition(c511000242.havefieldcon)
	c:RegisterEffect(e3)
	--Unaffected by Spell and Trap Cards
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetCondition(c511000242.havefieldcon)
	e4:SetValue(c511000242.unaffectedval)
	c:RegisterEffect(e4)
	--Cannot be Battle Target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(1)
	e5:SetCondition(c511000242.havefieldcon)
	c:RegisterEffect(e5)
	--Take Control
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(511000242,0))
	e6:SetCategory(CATEGORY_CONTROL)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c511000242.havefieldcon)
	e6:SetCost(c511000242.controlcost)
	e6:SetTarget(c511000242.controltg)
	e6:SetOperation(c511000242.controlop)
	c:RegisterEffect(e6)
	--Self Destroy During the End Phase
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetProperty(CATEGORY_DESTROY)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetCondition(c511000242.nofieldcon)
	e7:SetOperation(c511000242.nofieldop)
	c:RegisterEffect(e7)
	--When Leave the Field, Return the Control to Your Opponent
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_LEAVE_FIELD)
	e8:SetOperation(c511000242.returnop)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_LEAVE_FIELD)
	e9:SetOperation(c511000242.destroyop)
	c:RegisterEffect(e9)
end
function c511000242.setcon(e,c)
	if not c then return true end
	return false
end
function c511000242.havefieldfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FIELD)
end
function c511000242.havefieldcon(e)
	return Duel.IsExistingMatchingCard(c511000242.havefieldfilter,0,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler())
end
function c511000242.unaffectedval(e,te)
	return (te:IsActiveType(TYPE_SPELL) or te:IsActiveType(TYPE_TRAP)) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c511000242.tributefilter(c)
	return not c:IsPreviousLocation(LOCATION_MZONE,1,nil)
end
function c511000242.controlcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c511000242.tributefilter,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,c511000242.tributefilter,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c511000242.controlfilter(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c511000242.controltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c511000242.controlfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511000242.controlfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c511000242.controlfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c511000242.controlop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not Duel.GetControl(tc,tp) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function c511000242.nofieldcon(e)
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return (f1==nil or not f1:IsFaceup()) and (f2==nil or not f2:IsFaceup())
end
function c511000242.nofieldop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c511000242.nofieldcon)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c511000242.returnfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE,1,nil)
end
function c511000242.returnop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511000242.returnfilter,tp,LOCATION_MZONE,0,nil)
	local field=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if field>=g:GetCount() then
	local tc=g:GetFirst()
	while tc do
	Duel.GetControl(tc,1-tp)
	tc=g:GetNext()
	end
else
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONTROL)
	local sg=g:Select(1-tp,field,field,nil)
	local tc=sg:GetFirst()
	while tc do
	Duel.GetControl(tc,1-tp)
	tc=sg:GetNext()
	Duel.BreakEffect()
	end
end
end
function c511000242.destroyfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE,1,nil) and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c511000242.destroyop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c511000242.destroyfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
	Duel.Destroy(tc,REASON_EFFECT)
	tc=g:GetNext()
end
end