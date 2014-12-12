/*******************************************************************
  Program     : mobex/fetchClaimLines.p
  Description : RESTful Web Service for fetching a set of Claim Lines from the server
              : written for use with Mobile Expenses App
              : 
  By          : Mick Hand
  Date        : 19/06/2013

********************************************************************
                         Modification History  
********************************************************************


********************************************************************

#Notes######

Purpose...
   To return a temp-table of Claim Lines (ignoring attachments)
    
Parameters...
  lDebug 	logical
  pUserID
  pFilterGroup
  pFilterStatus
  pFilterDate
  output temp table of Claim Lines
	output lErrorFlag    logical
  output cErrorText

######Notes#                                                                    
  Security checks for MobEx Key and User/GUID should have been run via mobex/secCheck.p.

**********************************************************************/

def input param lDebug as log no-undo.
def input param pUserID as character no-undo.
def input param pFilterGroup as char no-undo.
def input param pFilterStatus as char no-undo.
def input parameter pFilterDate as char no-undo. /* CCYY-MM-DD */

def temp-table ttLines no-undo
  field ttlGroup as char
  field ttlType as char
  field ttlDate as char
  field ttlReason as char
  field ttlStatus as char /* "LOCKED" if it is on a claim, otherwise "FREE"  */
  field ttlAttachment as char /* relative path of file name */
  field ttlAmount as dec
  field ttlChkRecharge as log
  field ttlAdd_chkOutOfPolicy as log
  field ttlAdd_oopExplanation as char
  field ttlStoredJourney as char
  field ttlAdd_type as char
  field ttlAdd_visiting as char
  field ttlAdd_purpose as char
  field ttlAdd_fromLoc as char
  field ttlAdd_toLoc as char
  field ttlAdd_chkRoundtrip as log
  field ttlAdd_calcMiles as dec
  field ttlAdd_claimMiles as dec
  field ttlAdd_vehicle as char
  field ttlAdd_ytdMiles as dec
  field ttlAdd_people as char
  field ttlAdd_payee as char
  field ttlAdd_numPeople as int
  field ttlAdd_numNights as int
  field ttlAdd_chkIncEveMeal as log
  field ttlAdd_chkIncLunch as log
  field ttlAdd_chkIncBreakfast as log
  field ttlAdd_chkFlag as char
  field ttlAdd_value as dec
  field ttlAdd_resource as char
  field ttlAdd_proj as char
  field ttlChkNoReceipt as log
  field ttlUnique as char  /* objUnique */
  field ttlOnClaim as char /* objType / objID  */
.

def output param table for ttLines.
def output param lErrorFlag as log no-undo init NO.
def output param cErrorText as char no-undo init "".

def buffer bLine for objItem.

def var i as integer no-undo.
def var iLines as integer no-undo.
def var cStatus as char no-undo.
def var cAttachmentName as char no-undo.
def var cMobexForm as char no-undo init "ExpenseClaimLines".
def var cClaimDate as char no-undo.
def var dClaimDate as date no-undo.
def var dFilterDate as date no-undo.
def var dbug as logical no-undo.
{util/dbugChk.i &nomessage=nomessage}
{mobex/userDbugChk.i}

if lDebug = true then dbug = true.

if dbug then output to logs/debug_mobex_fetchClaimLines.log.

/* Get Mobex Form from Global Setting */
find first ssnVar no-lock
  where ssnVar.ssnUnique = "GLOBAL"
    and ssnVar.ssnVarName = "Mobex Form" no-error.
if avail ssnVar and ssnVar.ssnVarValue > "" then do:
  cMobexForm = ssnVarValue.
end.

if dbug then message "Mobex Form=" cMobexForm skip.

if pFilterDate > "" then
  ASSIGN
    cClaimDate = SUBSTRING(pFilterDate,9,2)
    cClaimDate = cClaimDate + "/" + SUBSTRING(pFilterDate,6,2)
    cClaimDate = cClaimDate + "/" + SUBSTRING(pFilterDate,1,4)
    dFilterDate = DATE(cClaimDate).
 
LOOP_LINES:
for each bLine no-lock
  where bLine.objType = cMobexForm 
    and bLine.uuserid = pUserID
  :

  if pFilterGroup > "" then do:
    if pFilterGroup <> bLine.fld03 then do:
      next LOOP_LINES.
    end.
  end.

  if pFilterStatus > "" then do:
    if pFilterStatus = "FREE" and bLine.fld06 > "" then do:
      next LOOP_LINES.
    end.
    if pFilterStatus = "USED" and bLine.fld06 = "" then do:
      next LOOP_LINES.
    end.
  end.

  if pFilterDate > "" then do:
    /* uses a field on the Form to hold the date of the claim (fld02) in the format CCYY-MM-DD)  */
   ASSIGN
     cClaimDate = SUBSTRING(bLine.fld02,9,2)
     cClaimDate = cClaimDate + "/" + SUBSTRING(bLine.fld02,6,2)
     cClaimDate = cClaimDate + "/" + SUBSTRING(bLine.fld02,1,4)
     dClaimDate = DATE(cClaimDate).
 
    if dClaimDate < dFilterDate then do:
      next LOOP_LINES.
    end.
  end.

  cStatus = (if bLine.fld06 > "" then "USED" else "FREE").
  cAttachmentName = bLine.fld07.

  create ttLines.
  assign
    ttlGroup = bLine.fld03
    ttlType = bLine.fld04
    ttlDate = bLine.fld02
    ttlReason = bLine.fld05
    ttlStatus = cStatus /* USED, FREE */
    ttlAttachment = cAttachmentName /* file name */
    ttlAmount = decimal(bLine.fld13)
    ttlChkRecharge = (bLine.fld14 = "ON")
    ttlAdd_chkOutOfPolicy = (bLine.fld15 = "ON")
    ttlAdd_oopExplanation = bLine.fld16
    ttlStoredJourney = bLine.fld17
    ttlAdd_type = bLine.fld18
    ttlAdd_visiting = bLine.fld19
    ttlAdd_purpose = bLine.fld20
    ttlAdd_fromLoc = bLine.fld21
    ttlAdd_toLoc = bLine.fld22
    ttlAdd_chkRoundtrip = (bLine.fld23 = "ON")
    ttlAdd_calcMiles = decimal(bLine.fld24)
    ttlAdd_claimMiles = decimal(bLine.fld25)
    ttlAdd_vehicle = bLine.fld26
    ttlAdd_ytdMiles = decimal(bLine.fld27)
    ttlAdd_people = bLine.fld28
    ttlAdd_payee = bLine.fld29
    ttlAdd_numPeople = int(bLine.fld30)
    ttlAdd_numNights = int(bLine.fld31)
    ttlAdd_chkIncEveMeal = (bLine.fld32 = "ON")
    ttlAdd_chkIncLunch = (bLine.fld33 = "ON")
    ttlAdd_chkIncBreakfast = (bLine.fld34 = "ON")
    ttlAdd_chkFlag = bLine.fld35
    ttlAdd_value = decimal(bLine.fld36)
    ttlAdd_resource = bLine.fld37
    ttlAdd_proj = bLine.fld38
    ttlChkNoReceipt = (bLine.fld39 = "ON")
    ttlUnique = bLine.objUnique
    ttlOnClaim = bLine.fld06
    .
  iLines = iLines + 1.

end. /* LOOP_LINES */

if dbug then message "Lines Returned = " iLines skip.

finally:
  if dbug then message "reached the finally" skip.
  if dbug then output close.
end.
