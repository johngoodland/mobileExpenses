/*******************************************************************
  Program     : mobex/updateClaimLine.p
  Description : Add or Modify a Claim Line
              : written for use with Mobile Expenses App
              : 
  By          : Mick Hand
  Date        : 03/04/2013

********************************************************************
                         Modification History  
********************************************************************

MPH 10/09/2013 added extra parameters

********************************************************************

#Notes######

Purpose...
   To create a Claim Line in eBIS
    
Parameters...
	lDebug 	logical
  pUserID
  
  params for each field in the Form
  
	output lErrorFlag    logical
  output cErrorText

######Notes#                                                                    
  Security checks for MobEx Key and User/GUID are to be called before running this.
  Expense Types are set up as valItem records in eBIS
  Expense Type Groups are another form of valItem
  Will use the Form Code provided as a Global Setting (or a User Extra Setting)
  Will drop the parameters into a template XML file and then run wFlow/xmlImports.p

**********************************************************************/

def input param lDebug as log no-undo.
def input param pUserID as character no-undo.

def input param pLineGUID as char no-undo init "". /* "objUnique" used to identify if a line is being changed rather than create a new line */
def input param pDate as date no-undo.
def input param pGroup as char no-undo.
def input param pType as char no-undo.       /* leave blank in POC */
def input param pReason as char no-undo.
def input param pCompany as int no-undo.     /* leave as 0 in POC */
def input param pDepartment as char no-undo. /* leave blank in POC */
def input param pAmount as dec no-undo.
def input param pRecharge as log no-undo.
def input param pStoredJourney as char no-undo.
def input param pAdd_chkOutOfPolicy as log no-undo.
def input param pAdd_oopExplanation as char no-undo.
def input param pAdd_type as char no-undo.
def input param pAdd_visiting as char no-undo.
def input param pAdd_purpose as char no-undo.
def input param pAdd_fromLoc as char no-undo.
def input param pAdd_toLoc as char no-undo.
def input param pAdd_chkRoundtrip as log no-undo.
def input param pAdd_calcMiles as dec no-undo.
def input param pAdd_claimMiles as dec no-undo.
def input param pAdd_vehicle as char no-undo.
def input param pAdd_ytdMiles as dec no-undo.
def input param pAdd_people as char no-undo.
def input param pAdd_payee as char no-undo.
def input param pAdd_numPeople as int no-undo.
def input param pAdd_numNights as int no-undo.
def input param pAdd_chkIncEveMeal as log no-undo.
def input param pAdd_chkIncLunch as log no-undo.
def input param pAdd_chkIncBreakfast as log no-undo.
def input param pAdd_chkFlag as char no-undo.
def input param pAdd_value as dec no-undo.
def input param pAdd_resource as char no-undo.
def input param pAdd_proj as char no-undo.
def input param pChkNoReceipt as log no-undo.
  
def output param lErrorFlag as log no-undo init NO.
def output param cErrorText as char no-undo init "".
def output param oLineGUID as char no-undo init "".

def var cFormCode as char no-undo.
def var cXMLTemplateFile as char no-undo.
def var cXMLTemplateFileFull as char no-undo.
def var cXMLTemplateFileTemp as char no-undo.
def var cXML as char no-undo.
def var iCompany as integer no-undo.
def var cDepartment as char no-undo.

def var dbug as logical no-undo.
{util/dbugChk.i &nomessage=nomessage}
{mobex/userDbugChk.i}

if lDebug = true then dbug = true.

if dbug then output to logs/debug_mobex_updateClaimLine.log.

run ipGetFormCode (output cFormCode).

/* TODO: find User Defaults ? Don't want to do this until we pull the line into a Claim */

if pLineGUID > "" then do:
  run ipFindLine. /* get the objUnique */
  if lErrorFlag then return.
end.

cXMLTemplateFile = "templateFiles/mobex_lines_" + cFormCode + ".xml".
cXMLTemplateFileFull = search(cXMLTemplateFile) no-error.
if cXMLTemplateFile = ? then do:
  lErrorFlag = true.
  cErrorText = "Mobex Template File not found for " + cFormCode.
  if dbug then message cErrorText skip.
end.
else do:
  if dbug then message "Mobex Template File found for " cFormCode skip.
end.

run ipGetTemplate (cXMLTemplateFileFull, output cXML).
if lErrorFlag then return.

run ipPopulateTemplate.

run ipWriteTempXML.

run wFlow/xmlImports.p (cXMLTemplateFileTemp, "").
/* gets the objUnique of the record just created */
oLineGUID = RETURN-VALUE.
if dbug then message "ObjUnique created was : " oLineGUID skip.

if not dbug then do:
  os-delete value(cXMLTemplateFileTemp).  
end.

finally:
  if dbug then message "reached the finally" skip.
  if dbug then output close.
end.

procedure ipGetFormCode:
def output parameter oFormCode as character no-undo.

  find first rscExtra no-lock
    where rscExtra.uuserid = pUserID
      and rscExtra.extraType = "MobEx Form Code" no-error.
  if avail rscExtra and rscExtra.data1 > "" then do:
    oFormCode = rscExtra.data1.
    return.
  end.
  find first ssnVar no-lock
    where ssnVar.ssnUnique = "GLOBAL"
      and ssnVar.ssnVarName = "MobEx Form Code" no-error.
  if avail ssnVar and ssnVar.ssnVarValue > "" then do:
    oFormCode = ssnVar.ssnVarValue.
    return.
  end.
  oFormCode = "ExpenseClaimLines".

end procedure. /* ipGetFormCode */

procedure ipFindLine:
  find first objItem no-lock
    where objItem.objUnique = pLineGUID no-error.
  if avail objItem then do:
    if objItem.fld06 > "" then do: 
      lErrorFlag = true.
      cErrorText = "Line cannot be modified as it has already been added to a Claim".
      if dbug then message cErrorText ":" objItem.fld06 skip.
      return.
    end.
    oLineGUID = pLineGUID.
    if dbug then message "Line found:" oLineGUID skip.
  end.
  else do:
    if dbug then message cFormCode " record not found" skip.
    pLineGUID = "".
  end.

end procedure. /* ipFindLine */

procedure ipGetTemplate:
def input  parameter pFileName as char no-undo.
def output parameter oTemplate as char no-undo.

  def var c as char no-undo.
  
  pFileName = search(pFileName).
  if pFileName = ? then do:
    lErrorFlag = true.
    cErrorText = "Template file not found for Form:" + cFormCode.
    if dbug then message cErrorText skip.
    return.
  end.

  /* run ipCheckFixEOF(pFileName). */ /* TODO: decide if we want to run this check each time ? */

  input from value(pFileName).
  repeat:
    c = "".
    import unformatted c.
    oTemplate = (if oTemplate > "" 
                then oTemplate + chr(10) 
                else "") + c.
  end.
  input close.

end procedure. /* ipGetTemplate */

FUNCTION fnXMLSafe RETURNS CHARACTER
  ( input pInputString as char) :
/*------------------------------------------------------------------------------
  Purpose: Encode a string so it is still valid in XML
  /* %%V30-0416 MPH 22/12/2005 */
------------------------------------------------------------------------------*/
  pInputString = replace(pInputString,"&","&#38;").
  pInputString = replace(pInputString,"£","&#163;").

/*
  pInputString = replace(pInputString,"<","&#60;").
  pInputString = replace(pInputString,">","&#62;").
*/  

  for each valItem no-lock
    where valItem.valType = "XMLSafe":

    pInputString = replace(pInputString,valItem.valCode,valitem.valData).

  end.

  return pInputString.

END FUNCTION.

procedure ipPopulateTemplate:

  def var tmpDate as char no-undo.

  if avail objItem then do:
    cXML = replace(cXML,"%ObjUnique","<objUnique>" + oLineGUID + "</objUnique>").  
    cXML = replace(cXML,"%User",objItem.uuserid).  
    cXML = replace(cXML,"%Stage",objItem.rtgStageName).  
    cXML = replace(cXML,"%GroupID",objItem.groupid).  
    cXML = replace(cXML,"%RoleID",objItem.roleid).  
  end.
  else do:
    cXML = replace(cXML,"%ObjUnique","").  
    cXML = replace(cXML,"%User",pUserID).  
    cXML = replace(cXML,"%Stage","Entry").  
    cXML = replace(cXML,"%GroupID","").  
    cXML = replace(cXML,"%RoleID","").  
  end.
  tmpDate = string(year(pDate),"9999") + "-" + string(month(pDate),"99") + "-" + string(day(pDate),"99"). 
  cXML = replace(cXML,"%cDate",tmpDate).  
  cXML = replace(cXML,"%cExpGroup",pGroup).  
  cXML = replace(cXML,"%cExpType",pType).  
  cXML = replace(cXML,"%txtReason",fnXMLSafe(pReason)).  
  cXML = replace(cXML,"%company",string(pCompany)).  
  cXML = replace(cXML,"%department",pDepartment).  
  cXML = replace(cXML,"%cAmount", trim(string(pAmount,">>>>>>9.99"))).  
  cXML = replace(cXML,"%chkRecharge",(if pRecharge then "ON" else "")).
  cXML = replace(cXML,"%cStoredJourney",fnXMLSafe(pStoredJourney)).  
  cXML = replace(cXML,"%lnAdd_chkOutOfPolicy",(if pAdd_chkOutOfPolicy then "ON" else "")).  
  cXML = replace(cXML,"%lnAdd_oopExplanation",fnXMLSafe(pAdd_oopExplanation)).  
  cXML = replace(cXML,"%lnAdd_type",fnXMLSafe(pAdd_type)).  
  cXML = replace(cXML,"%lnAdd_visiting",fnXMLSafe(pAdd_visiting)).  
  cXML = replace(cXML,"%lnAdd_purpose",fnXMLSafe(pAdd_purpose)).  
  cXML = replace(cXML,"%lnAdd_fromLoc",fnXMLSafe(pAdd_fromLoc)).  
  cXML = replace(cXML,"%lnAdd_toLoc",fnXMLSafe(pAdd_toLoc)).  
  cXML = replace(cXML,"%lnAdd_chkRoundtrip",(if pAdd_chkRoundtrip then "ON" else "")).  
  cXML = replace(cXML,"%lnAdd_calcMiles",trim(string(pAdd_calcMiles,">>>>>>>9.99"))) no-error.  
  cXML = replace(cXML,"%lnAdd_claimMiles",trim(string(pAdd_claimMiles,">>>>>>>9.99"))) no-error.  
  cXML = replace(cXML,"%lnAdd_vehicle",fnXMLSafe(pAdd_vehicle)).  
  cXML = replace(cXML,"%lnAdd_ytdMiles",trim(string(pAdd_ytdMiles,">>>>>>>9.99"))) no-error.  
  cXML = replace(cXML,"%lnAdd_people",fnXMLSafe(pAdd_people)).  
  cXML = replace(cXML,"%lnAdd_payee",fnXMLSafe(pAdd_payee)).  
  cXML = replace(cXML,"%lnAdd_NumPeople", trim(string(pAdd_numPeople,">>>>>>9"))).  
  cXML = replace(cXML,"%lnAdd_NumNights", trim(string(pAdd_numNights,">>>>>>9"))).  
  cXML = replace(cXML,"%lnAdd_chkIncEveMeal",(if pAdd_chkIncEveMeal then "ON" else "")).  
  cXML = replace(cXML,"%lnAdd_chkIncLunch",(if pAdd_chkIncLunch then "ON" else "")).  
  cXML = replace(cXML,"%lnAdd_chkIncBreakfast",(if pAdd_chkIncBreakfast then "ON" else "")).  
  cXML = replace(cXML,"%lnAdd_chkFlag",fnXMLSafe(pAdd_chkFlag)).  
  cXML = replace(cXML,"%lnAdd_value",trim(string(pAdd_value,">>>>>>>9.99"))) no-error.  
  cXML = replace(cXML,"%lnAdd_resource",fnXMLSafe(pAdd_resource)).  
  cXML = replace(cXML,"%lnAdd_proj",fnXMLSafe(pAdd_proj)).  
  cXML = replace(cXML,"%chkNoReceipt",(if pChkNoReceipt then "ON" else "")).  

end procedure. /* ipPopulateTemplate */

procedure ipWriteTempXML:

  cXMLTemplateFileTemp = "temp/mobex_" + pUserID + ".xml".
  output to value(cXMLTemplateFileTemp).
  put unformatted cXML chr(10) skip.
  output close.

end procedure. /* ipWriteTempXML */

