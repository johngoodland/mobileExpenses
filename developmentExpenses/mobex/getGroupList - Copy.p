/*******************************************************************
  Program     : mobex/getGroupList.p
  Description : RESTful Web Service for getting the list of Expense Type GROUPS
              : written for use with Mobile Expenses App
              : 
  By          : Mick Hand
  Date        : 02/04/2013

********************************************************************
                         Modification History  
********************************************************************


********************************************************************

#Notes######

Purpose...
   To return a temp-table of valid Expense Type Groups
   nb. there are too many Expense Types and we want to use
   simpler Groups such as Hotel, Taxi, Meal etc
    
Parameters...
  lDebug 	logical
  pUserID
  pLastGroup  (date/time of most recent data on phone)
  output temp table of Expense Type Groups
  output temp table of Out-Of-Policy Rules for each Group
  output temp table of Extra Fields for each Group
  
	output lErrorFlag    logical
  output cErrorText

######Notes#                                                                    
  Security checks for MobEx Key and User/GUID should have been run via mobex/secCheck.p.
  Expense Types are set up as valItem records in eBIS
  Expense Type Groups are another form of valItem

**********************************************************************/

def input param lDebug as log no-undo.
def input param pUserID as character no-undo.
def input param pLastGroup as char no-undo.

def temp-table ttGroups no-undo
  field ttgGroup as char
  field ttgDescription as char
  field ttgType as char /* currently MILEAGE or blank */
  field ttgPolicyLink as char
  field ttgRecModLast as char
.

def temp-table ttRules no-undo
  field ttrGroup as char
  field ttrRule as char
  field ttrLeftSide as char
  field ttrOperand as char
  field ttrRightSide as char
  field ttrMessage as char
.

def temp-table ttFields no-undo
  field ttfGroup as char
  field ttfOrder as int
  field ttfName as char
  field ttfLabel as char
  field ttfType as char
  field ttfMandatory as char
  field ttfDefault as char
.

def output param table for ttGroups.
def output param table for ttRules.
def output param table for ttFields.
def output param lErrorFlag as log no-undo init NO.
def output param cErrorText as char no-undo init "".

FUNCTION fnDefault RETURNS CHARACTER ( pDefaultOnAdd as char, pUser as char, pJS as log) FORWARD.

def var iGroups as integer no-undo.
def var cOOPString as char no-undo.
def var cOOPLine as char no-undo.
def var cOOPRule as char no-undo.
def var cOOPleftSide as char no-undo.
def var cOOPoperand as char no-undo.
def var cOOPrightSide as char no-undo.
def var cOOPMessage as char no-undo.
def var cFieldDef as char no-undo.
def var cFieldName as char no-undo.
def var cFieldLabel as char no-undo.
def var cFieldType as char no-undo.
def var cFieldMandatory as char no-undo.
def var cFieldLookup as char no-undo.
def var cFieldDefault as char no-undo.
def var cFieldOnlyMobile as char no-undo.
def var cPolicyLink as char no-undo.
def var cCompList as char no-undo.
def var cOAUser as char no-undo.
def var iRule as int no-undo init 0.
def var cUserLang as char no-undo.
def var cDummyErrors as char no-undo init "".
def var cComp as char no-undo init "".
def var iComp as int no-undo init 0.
def var lChanged as log no-undo init false.
def var cLastChanged as char no-undo init "".
def var iThisType as int no-undo.
def var iThisCompany as int no-undo init 0.
def var cDateFormat as char no-undo init "".
def var cLogFile as char no-undo init "".
def var i as integer no-undo.
def var iField as int no-undo init 0.
def var iNumFields as int no-undo init 0.
def var lTTGroupCreated as log no-undo init false.
def var lValidExpType as log no-undo init false.
def var lWantThis as log no-undo init false.
def temp-table ttCompanies no-undo
  field ttComp as int
  .
def temp-table ttTypes
  field ttType as char
  field ttGroup as char.

def buffer bExpGroup for valItem.
def buffer bExpType for valItem.

def var dbug as logical no-undo.
{util/dbugChk.i &nomessage=nomessage}
{mobex/userDbugChk.i}

if lDebug = true then dbug = true.

/*if dbug then output to logs/debug_mobex_getGroupList.log.*/

FUNCTION fnTran RETURNS CHARACTER
  ( pString as char ) :
/*------------------------------------------------------------------------------
  Purpose: Checks for a Translated version of the given string 
    Notes: A session variable called "UserLanguage" holds the 
           Language code of the current Session.
------------------------------------------------------------------------------*/

  if cUserLang = "" then do:
    return pString.
  end.
  find first lanString no-lock
    where lanString.lanCode = cUserLang
      and lanString.lanString = pString
      no-error.
  if not avail lanString then do:
    return pString.
  end.
  if lanString.lanString = "" then do:
    return pString.
  end.
  return lanString.lanTranslation.


END FUNCTION.
/*
&IF "{&mobile}" <> "no" &THEN
if dbug then cLogFile = "logs/debug_mobex_getGroupList.log".
&ELSE
if dbug then cLogFile = "logs/debug_getGroupList.log".
&ENDIF
*/


/* locate the User's company list */
find first rscMaster no-lock
  where rscMaster.uuserid = pUserID no-error.
if not avail rscMaster then do:
  lErrorFlag = true.
  cErrorText = "Invalid User:" + pUserID.
  run ipLog(cErrorText).
  return.
end.
cUserLang = rscMaster.lanCode.
if dbug then run ipLog("Found User:" + pUserID + " Language=" + cUserLang).
find first rscExtra no-lock
  where rscExtra.uuserid = pUserID
    and rscExtra.extraType = "OAUSER" no-error.
if not avail rscExtra then do:
  lErrorFlag = true.
  cErrorText = "No OAUSER setting for User:" + pUserID.
  run ipLog(cErrorText).
  return.
end.
cOAUser = rscExtra.data1.
if dbug then run ipLog("Found OAUSER for User:" + pUserID + "=" + cOAUser).
/*
run api/oa/usercompanies.p(input cOAUser, output cCompList, output cDummyErrors).

if dbug then run ipLog("Companies=" + cCompList).

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
*/
LOOP_GROUPS:
for each bExpGroup no-lock
  where bExpGroup.valType = "ExpTypeGroup"
    and bExpGroup.valCode2 = "HEADER":

   /* A valid Expense Type Group is one which is NOT obsolete, and for which the data has CHANGED since last requested (mobile only), 
   and for which there is at least ONE valid Expense Type. */
    
  /* Is it obsolete? */
  if lookup("X", bExpGroup.valdata) = 0 
 
  then do:
 
    /* See if any group data has changed - affects Mobile only. For non-mobile, want all valid groups */
    lChanged = false.
    cLastChanged = bExpGroup.recModTime.
    find first valitem no-lock 
      where valitem.valtype = "ExpTypeGroup" 
        and valitem.valcode = bExpGroup.valcode 
        and valitem.valcode2 = "FIELDS" no-error.
    if avail valitem then if valitem.recModTime > cLastChanged then cLastChanged = valitem.recModTime.
    find first valitem no-lock 
      where valitem.valtype = "ExpTypeGroup" 
        and valitem.valcode = bExpGroup.valcode 
         and valitem.valcode2 = "RULES" no-error.
    if avail valitem then if valitem.recModTime > cLastChanged then cLastChanged = valitem.recModTime.
   
&IF "{&mobile}" <> "no" &THEN
    lChanged = (trim(pLastGroup) = "") or (cLastChanged > pLastGroup).
&ELSE
    lChanged = true.
&ENDIF
 
    if lChanged then do:
  
      /* Try to find at least one valid Expense Type */
      lTTgroupCreated = false.
     
      for each bExpType no-lock
        where bExpType.valType = "ExpensesType"
        while not lTTgroupCreated:

        lWantThis = false.
        if num-entries(bExpType.valData) > 3 then lWantThis = entry(4, bExpType.valData) = bExpGroup.valcode.
        MESSAGE "iwant" lwantthis.
        if lWantThis then do:

          lValidExpType = TRUE.  
         /* if trim(bExpType.valCode2) = "" then do:
            lValidExpType = true.
          end.
          else do:
             
            cComp = trim(bExpType.valCode2).
            iComp = int(cComp) no-error. if iComp = ? then iComp = 0.
            if can-find(first ttCompanies where ttCompanies.ttComp = iComp) then do:
              
              lValidExpType = true.
              
            end.
            
          end.*/
          if lValidExpType then do:
             
            if lTTGroupCreated = false then do:
              
              /* Have found a valid expense type for this group, so create a group temp-table record */
              cPolicyLink = bExpGroup.valdata2.
             /* run wFlow/udfReplaceStrings.p (cPolicyLink,?,pUserID, output cPolicyLink).*/

              create ttGroups.
              assign
                ttGroups.ttgGroup = bExpGroup.valCode
                ttGroups.ttgDescription = fnTran(bExpGroup.description)
                ttGroups.ttgType = (if lookup("MT", bExpGroup.valData) <> 0 then "MILEAGE" else "")
                ttGroups.ttgPolicyLink = cPolicyLink
                ttGroups.ttgRecModLast = cLastChanged
                .
              iGroups = iGroups + 1.

              find first valitem no-lock
                where valitem.valtype = "ExpTypeGroup"
                  and valitem.valcode = bExpGroup.valCode
                  and valitem.valcode2 = "RULES"
                no-error.
              if avail valitem then do:
                    
                cOOPString = valitem.valData.

                LOOP_RULES:
                do iRule = 1 to num-entries(cOOPString):
                  assign
                    cOOPLine = entry(iRule, cOOPString)
                    cOOPRule = ""
                    cOOPMessage = ""
                    .
                  cOOPRule = entry(1,cOOPLine,"|") no-error. 
                  cOOPleftSide = entry(2,cOOPLine,"|") no-error.
                  cOOPoperand = entry(3,cOOPLine,"|") no-error.
                  cOOPrightSide = entry(4,cOOPLine,"|") no-error.
                  cOOPMessage = entry(5,cOOPLine,"|") no-error. 

                  create ttRules.
                  assign
                    ttrGroup = bExpGroup.valCode
                    ttrRule = cOOPRule
                    ttrLeftSide = fnDefault(cOOPleftSide, pUserId, true)    /* Want to replace e.g. TODAY in the expression */
                    ttrOperand = cOOPoperand
                    ttrRightSide = fnDefault(cOOPrightSide, pUserId, true)  /* Want to replace e.g. TODAY in the expression */
                    ttrMessage = cOOPMessage
                    .

                end. /* LOOP_RULES */
                
              end.
              
              iNumFields = 0.
              find first valitem no-lock
                where valitem.valtype = "ExpTypeGroup"
                  and valitem.valcode = bExpGroup.valCode
                  and valitem.valcode2 = "FIELDS"
                no-error.
              if avail valitem then do:

                LOOP_FIELDS:
                do iField = 1 to num-entries(valitem.valData):

                  assign
                    cFieldDef = entry(iField,valitem.valData)
                    cFieldLabel = ""
                    cFieldName = ""
                    cFieldType = ""
                    cFieldMandatory = ""
                    cFieldLookup = ""
                    cFieldDefault = ""
                    .

                  cFieldName = entry(1,cFieldDef,"|") no-error.
                  cFieldType = entry(2,cFieldDef,"|") no-error. /* text, textarea, decimal, integer, checkbox */ 
                  cFieldLabel = fnTran(entry(3,cFieldDef,"|")) no-error.
                  cFieldMandatory = entry(4,cFieldDef,"|") no-error. /* "M" or blank */
                  cFieldLookup =  entry(5,cFieldDef,"|") no-error.
                  cFieldDefault = entry(6,cFieldDef,"|") no-error.
                  cFieldOnlyMobile = if num-entries(cFieldDef,"|") > 6 then entry(7,cFieldDef,"|") else "".
                  if cFieldDefault <> "" then cFieldDefault = fnDefault(cFieldDefault, pUserId, false).

&IF "{&mobile}" = "no" &THEN
                  if cFieldOnlyMobile <> "M" then do:
&ENDIF
                    create ttFields.
                    assign
                      ttfGroup = bExpGroup.valCode
                      ttfName = cFieldName
                      ttfOrder = iField
                      ttfLabel = cFieldLabel
                      ttfType = cFieldType
                      ttfMandatory = cFieldMandatory
                      /*ttfLookup = cFieldLookup*/
                      ttfDefault = cFieldDefault
                      .
                  iNumFields = iNumFields + 1.

&IF "{&mobile}" = "no" &THEN
                  end.
&ENDIF
 
                end. /* LOOP_FIELDS */
              
              end.
              
              /* If group is a MILEAGE type, then ensure we return the From/To/Round Trip fields */
              if lookup("MT", bExpGroup.valData) <> 0 then do:
              
                if not can-find(first ttFields where ttfGroup = bExpGroup.valCode and ttfName = "lnAdd_fromLoc") then
                  run ipCreateMileageAddField(input bExpGroup.valCode, input "lnAdd_fromLoc", input "From Location", input-output iNumFields).
                if not can-find(first ttFields where ttfGroup = bExpGroup.valCode and ttfName = "lnAdd_toLoc") then
                  run ipCreateMileageAddField(input bExpGroup.valCode, input "lnAdd_toLoc", input "To Location", input-output iNumFields).
                if not can-find(first ttFields where ttfGroup = bExpGroup.valCode and ttfName = "lnAdd_chkRoundTrip") then
                  run ipCreateMileageAddField(input bExpGroup.valCode, input "lnAdd_chkRoundTrip", input "Round Trip", input-output iNumFields).
                  
              end.
 
              lTTGroupCreated = true.
              
            end.
            
          end.
        
        end.
      
      end.
    
    end.
  
  end.

end.

if dbug then run ipLog("Groups Returned = " + string(iGroups)).

finally:
  if dbug then run ipLog("reached the finally").
end.

FUNCTION fnDefault RETURNS CHARACTER
  ( pDefaultOnAdd as char, pUser as char, pJS as log) :
  
def var cReturn as char no-undo.
def var cDays as char no-undo.
def var iDays as int no-undo.
def var dtDay as date no-undo.
  
  pDefaultOnAdd = trim(pDefaultOnAdd).
  
  if pDefaultOnAdd = "" then return "".
  
  /* USERCODE */
  if pDefaultOnAdd = "USERCODE" then return pUser.

  if index(pDefaultOnAdd,"%") > 0 then do:
    run wFlow/udfReplaceStrings.p (pDefaultOnAdd,?,pUser, output cReturn).
    return cReturn.
  end.

  /* USERNAME */
  if pDefaultOnAdd = "USERNAME" then do:
    find first rscMaster no-lock
      where rscMaster.uuserID = pUser
      no-error.
    if avail rscMaster then return rscMaster.displayName.
  end.

  /* TODAY (+ or - an integer) */
  if pDefaultOnAdd begins "TODAY" then do:

    if cDateFormat = "" then do:
      cDateFormat = "DD/MM/YYYY".
      if pUser <> "" then do:
        find first rscExtra no-lock
          where rscExtra.uuserid = pUser 
            and rscExtra.extraType = "Date Format"
        no-error.
        if avail rscExtra and rscExtra.data1 <> '':U then
          assign cDateFormat = rscExtra.data1.
        else
        do:
          find first ssnVar no-lock
            where ssnVar.ssnUnique = "GLOBAL"
              and ssnVar.ssnVarName = "Date Format"
            no-error.
          if avail ssnVar then cDateFormat = ssnVar.ssnVarValue.
          if cDateFormat = '':U then cDateFormat = "DD/MM/YYYY".
        end.
      end.
    end.
    
    cDays = trim(substring(pDefaultOnAdd,6)) no-error. 
    /* cDays (if not blank) can only be +x or -x, both of which can be converted using int */
    if cDays <> '' then iDays = int(cDays) no-error. else iDays = 0.
    if iDays <> ? then dtDay = today + iDays. else dtDay = today.
    if not pJS then do:
      if cDateFormat begins "D" then 
        return string(day(dtDay),"99") + "/" + string(month(dtDay),"99") + "/" + string(year(dtDay),"9999").
      else
        return string(month(dtDay),"99") + "/" + string(day(dtDay),"99") + "/" + string(year(dtDay),"9999").
    end.
    else do:
      return "new Date(" + string(year(dtDay),"9999") + "," + string(month(dtDay) - 1,"99") + "," + string(day(dtDay),"99") + ")".
    end.

  end.
  
  return pDefaultOnAdd.
  
end function.

PROCEDURE ipCreateMileageAddField:

def input parameter pGroup as char no-undo.
def input parameter pFieldName as char no-undo.
def input parameter pFieldLabel as char no-undo.
def input-output parameter pNumFields as int no-undo.

  create ttFields.
  assign
    ttfGroup = pGroup
    ttfName = pFieldName
    ttfOrder = pNumFields + 1
    ttfLabel = pFieldLabel
    ttfType = "text"
    ttfMandatory = ""
    /*ttfLookup = "" */
    ttfDefault = ""
    .
                    
  pNumFields = pNumFields + 1.

END PROCEDURE.
PROCEDURE ipLog :
/*------------------------------------------------------------------------------
  Purpose:     write a line to the Log
  Parameters:  pMessage
  Notes:       if the log is not open, create it
------------------------------------------------------------------------------*/
def input parameter pMessage as char no-undo.

MESSAGE pMessage.
  /*
    output to value(cLogFile) append.
    put unformatted 
      "[" 
      + string(today,"99/99/9999") 
      + " " 
      + string(time,"HH:MM:SS") 
      + "] " 
      + pMessage skip.
    output close.
*/
END PROCEDURE.
