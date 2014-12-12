/** ****************************************************************************
  DataSet for Form data - groups, fields, rules 
**************************************************************************** **/
/*------------------------------------------------------------------------
    File        : dsFormData.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : 14 Nov 2013
    Notes       :
  ----------------------------------------------------------------------*/
 
DEFINE TEMP-TABLE eGroup NO-UNDO 
    FIELD cGroup AS CHARACTER 
    FIELD cDescription AS CHARACTER 
    FIELD cType AS CHARACTER /* currently MILEAGE or blank */
    FIELD cPolicyLink AS CHARACTER 
    FIELD cRecModLast AS CHARACTER 
    INDEX Primary IS PRIMARY cGroup.

DEFINE TEMP-TABLE eFields NO-UNDO 
    FIELD cGroup          AS CHARACTER 
    FIELD iFieldOrder     AS INTEGER 
    FIELD cFieldName      AS CHARACTER /* currently MILEAGE or blank */
    FIELD cFieldLabel     AS CHARACTER 
    FIELD cFieldDataType  AS CHARACTER
    FIELD cFieldMandatory AS CHARACTER /* O=Optional, M=Mandatory, D=Disabled */
    FIELD cFieldHidden    AS CHARACTER /* H=Hide S (or blank) =Show */
    INDEX Primary IS PRIMARY cGroup iFieldOrder cFieldName.

DEFINE TEMP-TABLE eRules NO-UNDO
    FIELD cGroup          AS CHARACTER 
    FIELD ttrRule		  AS CHARACTER
    field ttrLeftSide     as CHARACTER
    field ttrOperand      as CHARACTER
    field ttrRightSide    as CHARACTER
    field ttrMessage      AS CHARACTER.

DEFINE TEMP-TABLE eTypes NO-UNDO 
    FIELD cGroup          AS CHARACTER 
    FIELD cType           AS CHARACTER 
    FIELD cDescription    AS CHARACTER 
    FIELD cTypePrice      AS CHARACTER 
    FIELD cTypeMax        AS CHARACTER
    FIELD cRecModLast     AS CHARACTER 
    INDEX Primary IS PRIMARY cGroup cType.

define dataset dsFormData for eGroup, eFields, eRules, eTypes
    /* get the rules for the groups */
    data-relation for eGroup, eRules relation-fields (cGroup, cGroup)
    /* get the fields for the groups */
    data-relation for eGroup, eFields relation-fields (cGroup, cGroup)
    /* get the types for the groups */
    data-relation for eGroup, eTypes relation-fields (cGroup, cGroup).
	
{appServer/ebisexpensegroups.i}. 
