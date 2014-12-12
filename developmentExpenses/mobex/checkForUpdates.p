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
  output logical for Mileage Calc Licensed
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
def output param oMileageCalcLicensed as log no-undo.
def output param oGroupsChanged as log no-undo.
def output param oTypesChanged as log no-undo.
def output param lErrorFlag as log no-undo init NO.
def output param cErrorText as char no-undo init "".

def buffer bExpGroup for valItem.
def buffer bExpType for valItem.

def var cOAUser as char no-undo.

def var cRecModLastGroup as char no-undo.
def var cRecModLastType as char no-undo.
def var cCompList as char no-undo.

def temp-table ttTypes
  field ttType as char
  field ttGroup as char.

def var dbug as logical no-undo.
{util/dbugChk.i &nomessage=nomessage}
{mobex/userDbugChk.i}

if lDebug = true then dbug = true.

if dbug then output to logs/debug_mobex_checkForUpdates.log.

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

cCompList = "999,998,MickSaysFixThs".
if dbug then message "Companies=" + cCompList skip.

/* TODO Uncomment when you have openacc database
find first mnoperator no-lock
  where mnoperator.kinits =  cOAUser no-error.
if not avail mnoperator then do:
  lErrorFlag = true.
  cErrorText = "No USER record for:" + cOAUser.
  message cErrorText skip.
  return.
end.
cCompList = mnoperator.compstring.
if dbug then message "Companies=" + cCompList skip.
*/

/* TODO: check if MileageCalc is Licensed for this site the Global is a temporary frig until proper license check */
oMileageCalcLicensed = false.
find first ssnVar no-lock
  where ssnVar.ssnUnique = "GLOBAL"
    and ssnVar.ssnVarName = "MOBEX MileCalc" no-error.
if avail ssnVar then do:
  if ssnVar.ssnVarValue = "YES" then oMileageCalcLicensed = true.
end.

/* we only really care about Expense Type Groups where there are Expense Types available to this User */
/* Get the most recently updated Expense Type */
LOOP_TYPES:
for each bExpType no-lock
  where bExpType.valType = "ExpensesType", 
  first bExpGroup no-lock
  where bExpGroup.valType = "ExpTypeGroup"
    and bExpGroup.valCode = bExpType.valDataType
    and bExpGroup.valCode2 <> "X"    /* obsolete Groups */
    and bExpGroup.valCode2 <> "MX"   /* groups not wanted for mobile */
  :

  if bExpType.valCode3 > "" and bExpType.valCode3 <> "00" then do: /* company-specific? */
    if index(cCompList,bExpType.valCode3) = 0 then do:
      next LOOP_TYPES.
    end.
  end.

  create ttTypes.
  assign 
    ttTypes.ttType = bExpType.valCode
    ttTypes.ttGroup = bExpType.valDataType
    .

  if bExpType.recModTime > cRecModLastType then do:
    cRecModLastType = bExpType.recModTime.
  end.
end.

/* Get the most recently updated Expense Type Group */
/* ignore if no Types found for this User - based on Company */
for each bExpGroup no-lock
  where bExpGroup.valType = "ExpTypeGroup"
    and bExpGroup.valCode2 <> "X"    /* obsolete Groups */
    and bExpGroup.valCode2 <> "MX"   /* groups not to be available via Mobile */
  , first ttTypes 
      where ttTypes.ttGroup = bExpGroup.valCode
  :
  if bExpGroup.recModTime > cRecModLastGroup then do:
    cRecModLastGroup = bExpGroup.recModTime.
  end.
end.

message "Last group*********" cRecModLastGroup.
message "Last type*********" cRecModLastType.

oGroupsChanged = (cRecModLastGroup > pLastGroup).
oTypesChanged = (cRecModLastType > pLastType).

finally:
  if dbug then message "reached the finally LastGroup:" cRecModLastGroup 
                       " LastType:" cRecModLastType skip.
  if dbug then output close.
end.




