/*------------------------------------------------------------------------
    File        : mobex/addLinesToClaim.p
    Purpose     : add a set of lines
                  BASED ON GENERIC COLUMN DEFINITIONS
    Syntax      : Run via an AJAX call from the exp05_prototype form

    Description : Create tmpLines based on the mobex ExpenseClaimLines
    
    Author(s)   : Mick Hand
    Created     : 15/04/2013
    Notes       : 

  **************************************************************************
                     MODIFICATION   HISTORY
  **************************************************************************
  
  
                                                               
  **************************************************************************

  ------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
  
  /* standard lineprog variables */

  def buffer bHeader for objItem.

  def var cObjType as char no-undo.
  def var cObjUnique as char no-undo.
  def var iCols as int no-undo.
  def var i as int no-undo.
  def var cColName as char no-undo.
  def var cColValue as char no-undo.
  def var lColOK as log no-undo.

  def var hB as handle no-undo.
  def var hBF as handle no-undo.
  def var hBF2 as handle no-undo.
  def var hBF3 as handle no-undo.

  def var cErrString as char no-undo.
  
  def var dbug as log no-undo.

  {src/web/method/cgidefs.i}
  {util/ox_methods.i}	
  {util/dbugChk.i}
  
  /* local variables */
  def var iLines as integer no-undo.
  def var cLines as char no-undo.
  def var iRepeats as integer no-undo.
  def var cMobexForm as char no-undo init "ExpenseClaimLines".  /* TODO read from a setting */
  def var cLineType as char no-undo init "ExpenseLines".
  def var iNewRow as integer no-undo.
  def var cDate as char no-undo.

  def temp-table ttLine like tmpLine
    field tRecid as char.
  
FUNCTION fnColByName RETURNS CHARACTER
  ( buffer bLine for tmpLine, pName as char) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the value of a field on the tmpLine record
            by specifying the field's Name
    Notes:  Values are held in the generic fld01, fld02 etc fields on 
            the tmpLine record. The related objLnCol records give the
            Names and indicate which fldNN is required.
------------------------------------------------------------------------------*/
  def var i as int no-undo.
  def var hB as handle no-undo.
  def var hBF as handle no-undo.

  /* TODO get the perfomance fix for this function from Steve Chilton */

  for each objLnCol 
    where objLnCol.objtype = bLine.objType
      and objLnCol.lineType = bLine.lineType
      no-lock:
  
    if objLnCol.colName = pName then do:
      i = objLnCol.colNum.
      leave.
    end.
  end.

  if i = 0 then return "".

  hB = buffer bLine:handle.
  hBF = hB:buffer-field("fld" + left-trim(string(i,">99"))).
  return hBF:buffer-value.


END FUNCTION. /* fnColByName */
  
FUNCTION fnColHandleByName RETURNS HANDLE 
  (buffer bLine for tmpLine, pName as char ):
/*------------------------------------------------------------------------------
  Purpose: Returns handle to field
    Notes: 
------------------------------------------------------------------------------*/
  def var i as int no-undo.
  def var hB as handle no-undo.
  def var hBF as handle no-undo.
  
  /* TODO get the perfomance fix for this function from Steve Chilton */

  for each objLnCol 
    where objLnCol.objType = bLine.objType
      and objLnCol.lineType = bLine.lineType
      no-lock:
  
    if objLnCol.colName = pName then do:
      i = objlnCol.colNum.
      leave.
    end.
  end.

  if i = 0 then return ?.

  hB = buffer bLine:handle.
  hBF = hB:buffer-field("fld" + left-trim(string(i,">99"))).
  
  return hBF.

END FUNCTION.

/***************** Main Block ********************/

run process-web-request.

procedure process-web-request:

  def var cThisLine as char no-undo.
  def var iThisLine as integer no-undo.
  def var i as integer no-undo.
  def var iExisting as integer no-undo.

  cObjUnique = get-field("objUnique").
  cLines = get-field("lines").
  cLines = replace(cLines,"__sep__",",").
  iLines = num-entries(cLines).

  message "iLines=" iLines " cLines=" cLines skip.

  for each tmpLine no-lock
    where tmpLine.editUnique = cSessionUniqueID
      and tmpLine.objUnique = cObjUnique
      and tmpLine.lineType = cLineType:
    iExisting = iExisting + 1.
  end.

  do i = 1 to iLines:
    cThisLine = entry(i,cLines).
    iThisLine = int(cThisLine).
    find first objItem no-lock
      where objItem.objType = cMobexForm
        and objItem.objID = iThisLine no-error.
    if not avail objItem then do:
      message "Item missing - Form:" cMobExForm " ID:" iThisLine skip.
      next.
    end.
    iExisting = iExisting + 1.
    create tmpLine.
    assign
      tmpLine.editUnique = cSessionUniqueID
      tmpLine.objType = "EXP05_proto"
      tmpLine.objID = 2
      tmpLine.objUnique = cObjUnique
      tmpLine.lineType = cLineType
      tmpLine.fld01 = trim(string(iExisting,">99"))
      tmpLine.fld02 = objItem.fld02
      tmpLine.fld03 = objItem.fld03
      .

    message 
      tmpLine.editUnique " / " tmpLine.lineType 
      " Line=" tmpLine.fld01
      " Date=" tmpLine.fld02
      "  333=" tmpLine.fld03
      skip.

  end.

  /*
  for each tmpLine exclusive-lock
    where tmpLine.editUnique = cSessionUniqueID
      and tmpLine.lineType   = cLineType:
    iNewRow = iNewRow + 1.
    create ttLine.
    buffer-copy tmpLine except fld01 to ttLine .
    assign 
      ttLine.fld01 = string(iNewRow)
      ttLine.tRecid = string(recid(tmpLine))
    .
    
    if int(ttLine.tRecid) = int(iLineKey) then do:
      do i = 2 to iRepeats:
        run ipGetNextDate(ttLine.fld21, output cDate).
        iNewRow = iNewRow + 1.
        create ttLine.
        buffer-copy tmpLine except fld01 to ttLine.
        assign 
          ttLine.fld01 = string(iNewRow)
          ttLine.tRecid = string(recid(tmpLine))
          ttLine.fld21 = cDate
        .
      end.
    end.
  end.


  for each ttLine:
    message ttLine.fld01 ttline.fld08 ttLine.fld11 ttLine.fld21 skip.
  end.

  for each tmpLine EXCLUSIVE-LOCK
    where tmpLine.editUnique = cSessionUniqueID
      and tmpLine.lineType   = cLineType:
    delete tmpLine.
  end.

  for each ttLine:
    create tmpLine.
    buffer-copy ttLine to tmpLine.
    delete ttLine.
  end.
  */

  run outputHeader.

  {&OUT} "// alert('" + string(iLines) + " lines created');" skip.

  
end procedure. /* process-web-request */

PROCEDURE outputHeader :
/*------------------------------------------------------------------------------
  Purpose:     Output the MIME header, and any "cookie" information needed 
               by this procedure.  
  Parameters:  <none>
  Notes:       In the event that this Web object is state-aware, this is
               a good place to set the webState and webTimeout attributes.
------------------------------------------------------------------------------*/

    output-content-type ("text/html":U).
  
END PROCEDURE.

