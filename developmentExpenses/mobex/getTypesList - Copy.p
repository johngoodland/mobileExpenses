/*******************************************************************
  Program     : mobex/getTypesList.p
  Description : RESTful Web Service for getting the list of Expense Types
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
   To return a temp-table of valid Expense Types
    
Parameters...
  lDebug 	logical
  pUserID
  pLastType  (date/time of most recent data on phone)
  output temp table of Expense Types
	output lErrorFlag    logical
  output cErrorText

######Notes#                                                                    
  Security checks for MobEx Key and User/GUID should have been run via mobex/secCheck.p.
  Expense Types are set up as valItem records in eBIS
  Expense Type Groups are another form of valItem

**********************************************************************/

def input param lDebug as log no-undo.
def input param pUserID as character no-undo.
def input param pLastType as char no-undo.

def temp-table ttTypes no-undo
  field tttGroup as char
  field tttType as char
  field tttDescription as char
  field tttPrice as char /* currently MILEAGE or blank */
  field tttMax as char
  field tttRecModLast as char
.

def output param table for ttTypes.
def output param lErrorFlag as log no-undo init NO.
def output param cErrorText as char no-undo init "".

def buffer bExpGroup for valItem.
def buffer bExpType for valItem.

def var i as integer no-undo.
def var iTypes as integer no-undo.
def var cPrice as char no-undo.
def var cMax as char no-undo.
def var cOAUser as char no-undo.
def var cDefaultCompany as char no-undo.

def var dbug as logical no-undo.
{util/dbugChk.i &nomessage=nomessage}
if lDebug = true then dbug = true.

if dbug then output to logs/debug_mobex_getTypesList.log.

/* locate the User's default company */
find first rscMaster no-lock
  where rscMaster.uuserid = pUserID no-error.
if not avail rscMaster then do:
  lErrorFlag = true.
  cErrorText = "Invalid User:" + pUserID.
  message cErrorText skip.
  return.
end.
if dbug then message "Found User:" pUserID skip.
find first rscExtra no-lock
  where rscExtra.uuserid = pUserID
    and rscExtra.extraType = "OAUSER" no-error.
if not avail rscExtra then do:
  lErrorFlag = true.
  cErrorText = "No OAUSER setting for User:" + pUserID.
  message cErrorText skip.
  return.
end.
cOAUser = rscExtra.data1.
if dbug then message "Found OAUSER for User:" pUserID "=" cOAUser skip.

find first mnoperator no-lock
  where mnoperator.kinits =  cOAUser no-error.
if not avail mnoperator then do:
  lErrorFlag = true.
  cErrorText = "No USER record for:" + cOAUser.
  message cErrorText skip.
  return.
end.
cDefaultCompany = entry(1,mnoperator.compstring).
if dbug then message "Found Default Company:" cDefaultCompany skip.

/* TODO: we only really care about Expense Type Groups where there 
         are Expense Types available to this User */

LOOP_GROUPS:
for each bExpGroup no-lock
  where bExpGroup.valType = "ExpTypeGroup"
    and bExpGroup.valCode2 <> "X"    /* obsolete Groups */
    and bExpGroup.valCode2 <> "MX"   /* groups not to be available via Mobile */
  :

  /* Fetch the list of Expense Types - only the Types linked to Groups we intend to show */
  LOOP_TYPES:
  for each bExpType no-lock
    where bExpType.valType = "ExpensesType"
      and bExpType.valDataType = bExpGroup.valCode:
    
    /* only include types available to default company or all companies */
    if bExpType.valCode2 > ""
    and bExpType.valCode2 <> "00" then do:
      if bExpType.valCode2 <> cDefaultCompany then do:
        next LOOP_TYPES.
      end.
    end.

    if pLastType > "" then do:
      if bExpType.recModTime <= pLastType then next LOOP_TYPES.
    end.

    assign
      cPrice = ""
      cMax = ""
      .

    cPrice = entry(1,bExpType.valData) no-error.
    cMax = entry(2,bExpType.valData) no-error.

    create ttTypes.
    assign
      tttGroup = bExpType.valDataType
      tttType = bExpType.valCode
      tttDescription = bExpType.description
      tttPrice = cPrice
      tttMax = cMax
      tttRecModLast = bExpType.recModTime
      .
    iTypes = iTypes + 1.

  end. /* LOOP_TYPES */

end.

if dbug then message "Types Returned = " iTypes skip.

finally:
  if dbug then message "reached the finally" skip.
  if dbug then output close.
end.




