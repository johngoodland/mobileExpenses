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
  field tttPrice as char /* default Unit Price */
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
def var cCompList as char no-undo.
def var cGroupType as character no-undo.

def var cDummyErrors as char no-undo init "".
def var cCoListProg as char no-undo init "".
def var lValidExpType as log no-undo init false.
def var iThisCompany as int no-undo init 0.
def var cComp as char no-undo init "".
def var iComp as int no-undo init 0.

def temp-table ttCompanies no-undo
  field ttComp as int
  .

def var dbug as logical no-undo.
{util/dbugChk.i &nomessage=nomessage}
{mobex/userDbugChk.i}

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

cCompList = "".
cCoListProg = search("api/oa/usercompanies.r").
if cCoListProg = ? then cCoListProg = search("api/oa/usercompanies.p").
if cCoListProg <> ? then do:

  run value(cCoListProg)(input cOAUser, output cCompList, output cDummyErrors).

end.
else do:

  find first mnoperator no-lock
  where mnoperator.kinits =  cOAUser no-error.
  if avail mnoperator then cCompList = mnoperator.compstring.

end.

if dbug then message "Companies=" + cCompList skip.

do iThisCompany = 1 to num-entries(cCompList):

  cComp = trim(entry(iThisCompany, cCompList)).
  iComp = int(cComp) no-error. if iComp = ? then iComp = 0.
  find first ttCompanies no-lock
    where ttCompanies.ttComp = iComp
    no-error.
  if not avail ttCompanies then do:
    create ttCompanies.
    assign
      ttCompanies.ttComp = iComp
      .      
  end.

end.


/* ignore ones flagged as not for mobile or obsolete or not linked to any Types visible to the User */

LOOP_TYPES:
for each bExpType no-lock
  where bExpType.valType = "ExpensesType": 

  lValidExpType = false.  

  cGroupType = "".
  if num-entries(bExpType.valdata) > 3 then cGroupType = trim((entry(4,  bExpType.valdata))).

  if cGroupType <> "" then do:
  
    for first bExpGroup no-lock
    where bExpGroup.valType = "ExpTypeGroup"
	  and bExpGroup.valCode = cGroupType
      and lookup("MX", bExpGroup.valdata) > 0 :
      
      lValidExpType = true.  
      
    end.
    
  end.
  
  if lValidExpType then do:

    lValidExpType = false.  
    if trim(bExpType.valCode2) = "" then do:
      lValidExpType = true.
    end.
    else do:
             
      cComp = trim(bExpType.valCode2).
      iComp = int(cComp) no-error. if iComp = ? then iComp = 0.
      if can-find(first ttCompanies where ttCompanies.ttComp = iComp) then do:
              
        lValidExpType = true.
              
      end.
            
    end.
    
  end.

  if lValidExpType then do:

    if pLastType > "" then do:
      if bExpType.recModTime <= pLastType then lValidExpType = false.
    end.
    
  end.

  if lValidExpType then do:
  
    assign
      cPrice = ""
      cMax = ""
      . 

    cPrice = entry(1,bExpType.valData) no-error.
    cMax = entry(2,bExpType.valData) no-error.

    create ttTypes.
    assign
      tttGroup = cGroupType
      tttType = bExpType.valCode
      tttDescription = (if bExpType.description <> "" then bExpType.description else bExpType.valCode)
      tttPrice = cPrice
      tttMax = cMax
      tttRecModLast = bExpType.recModTime
      .
  
    iTypes = iTypes + 1.
    
  end.
  
end. /* LOOP_TYPES */

if dbug then message "Types Returned = " iTypes skip.

finally:
  if dbug then message "reached the finally" skip.
  if dbug then output close.
end.




