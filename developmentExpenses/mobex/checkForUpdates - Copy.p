/*******************************************************************
  Program     : mobex/checkForUpdates.p
  Description : RESTful Web Service for checking whether Updates are required
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
   To return a flag to indicate that GroupTypes or Types have been changed recently
    
Parameters...
  lDebug 	logical
  pUserID
  pLastGroup
  pLastType
  output logical for Group Types
  output logical for Expense Types
	output lErrorFlag    logical
  output cErrorText

######Notes#                                                                    
  Security checks for MobEx Key and User/GUID should have been run via mobex/secCheck.p.
  Expense Types are set up as valItem records in eBIS
  Expense Type Groups are another form of valItem

**********************************************************************/

def input param lDebug as log no-undo.
def input param pUserID as character no-undo.
def input  parameter pLastGroup as character no-undo.
def input  parameter pLastType as character no-undo.
def output param oGroupsChanged as log no-undo.
def output param oTypesChanged as log no-undo.
def output param lErrorFlag as log no-undo init NO.
def output param cErrorText as char no-undo init "".

def buffer bExpGroup for valItem.
def buffer bExpType for valItem.

def var cOAUser as char no-undo.
def var cDefaultCompany as char no-undo.
def var cRecModLastGroup as char no-undo.
def var cRecModLastType as char no-undo.

def var dbug as logical no-undo.
{util/dbugChk.i &nomessage=nomessage}
if lDebug = true then dbug = true.

if dbug then output to logs/debug_mobex_checkForUpdates.log.

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

/* Get the most recently updated Expense Type Group */
for each bExpGroup no-lock
  where bExpGroup.valType = "ExpTypeGroup"
    and bExpGroup.valCode2 <> "X"    /* obsolete Groups */
    and bExpGroup.valCode2 <> "MX"   /* groups not to be available via Mobile */
  :
  if bExpGroup.recModTime > cRecModLastGroup then do:
    cRecModLastGroup = bExpGroup.recModTime.
  end.
end.

/* Get the most recently updated Expense Type */
for each bExpType no-lock
  where bExpType.valType = "ExpensesType":
  /* TODO: Exclude Types linked to Groups that are X or MX */
  if bExpType.recModTime > cRecModLastType then do:
    cRecModLastType = bExpType.recModTime.
  end.
end.

oGroupsChanged = (cRecModLastGroup > pLastGroup).
oTypesChanged = (cRecModLastType > pLastType).

finally:
  if dbug then message "reached the finally LastGroup:" cRecModLastGroup 
                       " LastType:" cRecModLastType skip.
  if dbug then output close.
end.




