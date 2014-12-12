
var oopArray = new Array;
function oopItem (ruleType, ruleParams, ruleMessage)
{
  this.ruleType = ruleType;
  this.ruleParams = ruleParams;
  this.ruleMessage = ruleMessage;
}
// dummy data - Out of Policy Rules for MILEAGE Group
oopArray[oopArray.length] = new oopItem('COMPARE','cCalcMiles,<,cClaimMiles','Claim higher than Calculated Miles'); 
oopArray[oopArray.length] = new oopItem('RATE','',''); 
oopArray[oopArray.length] = new oopItem('MAX','',''); 
oopArray[oopArray.length] = new oopItem('MAXPER','cTotal,cPeople',''); 

var fldArray = new Array;
function fldItem (fldName, fldLabel, fldDataType, fldMode, fldHide)
{
  this.fldName = fldName;
  this.fldLabel = fldLabel;
  this.fldDataType = fldDataType;
  this.fldMode = fldMode;  // O=Optional, M=Mandatory, D=Disabled
  this.fldHide = fldHide;  // H=Hide S (or blank) =Show
}
// dummy data - fields for MILEAGE Group
/*
fldArray[fldArray.length] = new fldItem('cExpGroup','Group','text','O','S'); 
fldArray[fldArray.length] = new fldItem('cExpType','Type','select','O','S'); 
fldArray[fldArray.length] = new fldItem('cExpDate','Date','text','M','S'); 
fldArray[fldArray.length] = new fldItem('cExpReason','Reason','text','M','S'); 
fldArray[fldArray.length] = new fldItem('cExpAmount','Amount','decimal','M','S'); 
fldArray[fldArray.length] = new fldItem('cExpCharge','Recharge Customer','text','O','S'); 
fldArray[fldArray.length] = new fldItem('cExpPurpose','Purpose','text','O','S'); 
fldArray[fldArray.length] = new fldItem('cExpOOP','OOP Reason','textarea','M','H'); 
fldArray[fldArray.length] = new fldItem('cExpPayee','Payee','text','O','H'); 
fldArray[fldArray.length] = new fldItem('cExpNoPeople','No. People','text','O','H'); 
fldArray[fldArray.length] = new fldItem('cExpNoNights','No. Nights','text','O','S'); 
fldArray[fldArray.length] = new fldItem('cExpEveMeal','Includes Evening Meal','text','O','S'); 
fldArray[fldArray.length] = new fldItem('cExpBreak','Includes Breakfast','text','O','S'); 
fldArray[fldArray.length] = new fldItem('cExpLunch','Includes Lunch','text','O','S'); */
//fldArray[fldArray.length] = new fldItem('cCalcMiles','Calc Miles','decimal','D','S'); 
//fldArray[fldArray.length] = new fldItem('cClaimMiles','Claim Miles','decimal','O','S'); 
//fldArray[fldArray.length] = new fldItem('cOOPReason','Explanation','textarea','M','H'); 
//fldArray[fldArray.length] = new fldItem('cPeople','Passengers','decimal','O','S');
//fldArray[fldArray.length] = new fldItem('cTotal','Total Claim','decimal','O','S'); 

var typeArray = new Array;
function typeItem (typeCode, typeName, typePrice, typeMax)
{
  this.typeCode = typeCode;
  this.typeName = typeName;
  this.typePrice = typePrice;
  this.typeMax = typeMax;
}
// dummy data - Expense Types for MILEAGE Group
typeArray[typeArray.length] = new typeItem('MIL1232','Business Miles upto 10K (45p)','0.45','200'); 
typeArray[typeArray.length] = new typeItem('MIL1233','Business Miles over 10K (25p)','0.25','100'); 


function myReady()
{
  populateTypeSelect();
  layoutPage();
  // shuffling done with mainContent hidden then show when all ready
  document.getElementById("mainContent").style.display = "";
}

function populateTypeSelect()
{
  var oSelect = document.getElementById("cExpType");
     
  for(i=0;i<=typeArray.length-1;i++)
  {
    var oOption = document.createElement("OPTION");
    oSelect.options.add(oOption);
    oOption.innerHTML = typeArray[i].typeName;
    oOption.value = typeArray[i].typeCode;
  }
  changedType();
}

function changedType()
{
  var oSelect = document.getElementById("cExpType");
  var iExpType = oSelect.selectedIndex;
  //alert(thisExpType);
  document.getElementById("cPrice").value = typeArray[iExpType].typePrice;
  document.getElementById("cMax").value = typeArray[iExpType].typeMax;
}
function layoutPage()
{
    
var selectedValue = localStorage.getItem("sessionGroup");
var data = localStorage.getItem("ResultFields");
var FieldList = [];  
var fldArray = new Array;
var parsedFields = JSON.parse(data);
var JSONFields = JSON.stringify(parsedFields.eFields);
var parsed = JSON.parse(JSONFields);
    
for (var i = 0; i < parsed.length; ++i)
      
  if (selectedValue  == parsed[i].cGroup)
    {
      var item = 
          { "Field": parsed[i].cFieldName,
            "Label": parsed[i].cFieldLabel,
            "DataType": parsed[i].cFieldDataType,
            "Mandatory": parsed[i].cFieldMandatory,
            "Hidden": parsed[i].cFieldHidden  };
      FieldList.push(item);
      fldArray[fldArray.length] = new fldItem(parsed[i].cFieldName,parsed[i].cFieldLabel,parsed[i].cFieldDataType,parsed[i].cFieldMandatory,parsed[i].cFieldHidden); 
      console.log('Found Field data pushing to JSONTypes storage.');
  	};

 
  var others = document.querySelectorAll('.Mandatory');
    // if there *are* any elements with that class-name:
    if (others.length){
        // iterate through that collection, removing the class-name:
        for (var i = 0, len = others.length; i < len; i++){
            others[i].classList.remove('Mandatory');
        }
    }
//myReady();
//  document.getElementById("mobilecontainer1").style.display = "none";
var myTable = Tiggzi("mainTable").get(0);
var innerRows = myTable.getElementsByTagName("tr");
myExpGrpRow.style.display = "none";
myExpTypeRow.style.display = "none";
myExpDateRow.style.display = "none";
myExpReasonRow.style.display = "none";
myExpAmountRow.style.display = "none";
myExpChargeRow.style.display = "none";
myExpPurposeRow.style.display = "none";
myExpOOPRow.style.display = "none";
myExpPayeeRow.style.display = "none";
myExpNoPeopleRow.style.display = "none";
myExpNoNightRow.style.display = "none";
myEveMealRow.style.display = "none";
myExpBreakRow.style.display = "none";
myExpLunchRow.style.display = "none";
myExpVisitRow.style.display = "none";
myExpFromRow.style.display = "none";
myExpToRow.style.display = "none";
myExpRoundRow.style.display = "none";
myExpMapRow.style.display = "none";
myExpCalcMilesRow.style.display = "none";
MyExpClaimMilesRow.style.display = "none";
MyExpVehicleRow.style.display = "none";
MyExpYTDMilesRow.style.display = "none";
MyExpPeopleRow.style.display = "none";
var thisRow;
var tmpNode;
var mandatoryList = "";
 
for (i=0;i<fldArray.length ;i++ )
  {
    cFldName = fldArray[i].fldName;
  //  cRowName = cFldName  
    cLabelName = cFldName + "_Lab";
    cLabel = fldArray[i].fldLabel;

    // shuffle the fields into order
    if (cFldName == 'cExpGroup') {thisRow =  myExpGrpRow};
    if (cFldName == 'cExpType') {thisRow =  myExpTypeRow};
    if (cFldName == 'cExpDate') {thisRow =  myExpDateRow};
    if (cFldName == 'cExpReason') {thisRow =  myExpReasonRow};
    if (cFldName == 'cExpAmount') {thisRow =  myExpAmountRow};
    if (cFldName == 'cExpCharge') {thisRow =  myExpChargeRow};
    if (cFldName == 'cExpPurpose') {thisRow =  myExpPurposeRow};
    if (cFldName == 'cExpOOP') {thisRow =  myExpOOPRow};
    if (cFldName == 'cExpPayee') {thisRow =  myExpPayeeRow};
    if (cFldName == 'cExpNoPeople') {thisRow =  myExpNoPeopleRow};
    if (cFldName == 'cExpNoNights') {thisRow =  myExpNoNightRow};
    if (cFldName == 'cExpEveMeal') {thisRow =  myEveMealRow};
    if (cFldName == 'cExpBreak') {thisRow =  myExpBreakRow};
    if (cFldName == 'cExpLunch') {thisRow =  myExpLunchRow};
    if (cFldName == 'cExpPeople') {thisRow =  MyExpPeopleRow};
    if (cFldName == 'cExpVisit') {thisRow =  myExpVisitRow};
    if (cFldName == 'cExpFrom') {thisRow =  myExpFromRow};
    if (cFldName == 'cExpTo') {thisRow =  myExpToRow};
    if (cFldName == 'cExpRound') {thisRow =  myExpRoundRow};
    if (cFldName == 'cExpMap') {thisRow =  myExpMapRow};
    if (cFldName == 'cExpCalcMiles') {thisRow =  myExpCalcMilesRow};
    if (cFldName == 'cExpClaimMiles') {thisRow =  MyExpClaimMilesRow};
    if (cFldName == 'cExpVehicle') {thisRow =  MyExpVehicleRow};
    if (cFldName == 'cExpYTDMiles') {thisRow =  MyExpYTDMilesRow};
  //  alert(cRowName);
    //thisRow = document.getElementById(cRowName);
	//alert(cRowName);
    tmpNode = myTable.tBodies[0].replaceChild(thisRow, myFirstRow);
    tmpNode.tabindex = i;
    myTable.tBodies[0].insertBefore(tmpNode, myDummyRow);
        // Hide & Show
    if (fldArray[i].fldHide=='H')
    {
      thisRow.style.display = "none";
    }
    else
    {
      thisRow.style.display = "";
    }

    // Set Labels
   // Tiggzi(cLabelName).get(0)
    Appery(cLabelName).get(0).innerHTML = cLabel + ':';
    Appery(cFldName).get(0).readOnly = false;
    var fldMobileAmount = Tiggr(cFldName);
    Appery(cFldName).removeClass('Mandatory');
    fldMobileAmount.removeClass('ui-disabled');
  
        // Mandatory & Disabled
    if (fldArray[i].fldMode=='M')
    {
       Tiggzi(cLabelName).get(0).innerHTML += '<span style="color:red">*</span>';
   
       Appery(cFldName).parent().css('border','2px solid #ff0000');
       Appery(cFldName).addClass('Mandatory');
     // Tiggzi(cFldName).css('border','1px red solid ');
       mandatoryList = Appery(cFldName);
     
       $(mandatoryList).bind('keyup', function() {
         if(allFilled()) 
         {
           Appery('mobileDoneReceipt').removeClass('ui-disabled'); 
           Appery('mobileDoneReceipt').addClass('buttonOK');
         }
         else
         {
           Appery('mobileDoneReceipt').removeClass('buttonOK');
           Appery('mobileDoneReceipt').addClass('ui-disabled')
         }
       });
   
    }
    else if (fldArray[i].fldMode=='D')
    {
      Appery(cFldName).get(0).readOnly = true;
      var fldMobileAmount = Tiggr(cFldName);
      fldMobileAmount.addClass('ui-disabled'); 
      Appery(cFldName).parent().css('border','1px solid #CCCCCC');
      //Tiggzi(cFldName).get(0).style.backgroundColor = "#EEEEEE";
    }
    
  }
 
}
function allFilled() {
    var filled = true;
    $('body .Mandatory').each(function() {
        if($(this).val() == '') filled = false;
    });
    return filled;
}
 
function layoutPageOLD()
{
  var cFldName = "";
  var myTable = document.getElementById("mainTable");
  var myFirstRow = document.getElementById("myFirst_Row");
  var myDummyRow = document.getElementById("myDummy_Row");
  var thisRow;
  var tmpNode;

  for (i=0;i<fldArray.length ;i++ )
  {
    cFldName = fldArray[i].fldName;
    cRowName = cFldName + "_Row";
    cLabelName = cFldName + "_Lab";
    cLabel = fldArray[i].fldLabel;

    // shuffle the fields into order
    thisRow = document.getElementById(cRowName);
    tmpNode = myTable.tBodies[0].replaceChild(thisRow, myFirstRow);
    myTable.tBodies[0].insertBefore(tmpNode, myDummyRow);
 

    // Hide & Show
    if (fldArray[i].fldHide=='H')
    {
      document.getElementById(cRowName).style.display = "none";
    }
    else
    {
      document.getElementById(cRowName).style.display = "";
    }

    // Set Labels
    document.getElementById(cLabelName).innerHTML = cLabel + ':';

    // Mandatory & Disabled
    if (fldArray[i].fldMode=='M')
    {
      document.getElementById(cLabelName).innerHTML += '<span style="color:red">*</span>';
    }
    else if (fldArray[i].fldMode=='D')
    {
      document.getElementById(cFldName).readOnly = true;
      document.getElementById(cFldName).style.backgroundColor = "#EEEEEE";
    }
  }
}

function getMilesHTML()
{
  var cCalc = 50.00;
  try
  {
    cCalc = parseFloat(prompt("Simulate Calc Miles",50.00));    
  }
  catch (e)
  {
    alert("Enter a number, twit");
    return;
  }

  if (isNaN(cCalc))
  {
    alert("Enter a number, twit");
    return;
  }

  document.getElementById("cCalcMiles").value = cCalc.toString() ;
  if (document.getElementById("cClaimMiles").value=="")
  {
    document.getElementById("cClaimMiles").value = cCalc.toString();
    document.getElementById("cClaimMiles").focus();
  }
}

function checkPolicy()
{
  var decValue1 = 0.00;
  var decValue2 = 0.00;
  var decValue3 = 0.00;
  var oopMess = "OUT OF POLICY";
  var oopFlag = false;
  var i = 0;
  var iType = 0;
  var cExpType = ""
  var oSelect = document.getElementById("cExpType");
  var iExpType = oSelect.selectedIndex;
  var cRuleType = "";
  var cRuleParams = "";
  var cRuleMessage = "";
  var cOperator = "";
  var cParamArray = new Array;

  // Loop through the Rules
  for (i=0; i<oopArray.length ;i++ ) 
  {
    cRuleType = oopArray[i].ruleType;
    cRuleParams = oopArray[i].ruleParams;
    cRuleMessage = oopArray[i].ruleMessage;

    if (cRuleType=="RATE")
    {
      // find the default Rate for this type and check if it has changed
      decValue1 = parseFloat(document.getElementById("cPrice").value);
      decValue2 = parseFloat(typeArray[iExpType].typePrice);
      if (decValue1 != decValue2)
      {
        oopFlag = true;
        if (cRuleMessage == "") cRuleMessage = "Rate changes require explanation";
        oopMess += "\n" + cRuleMessage;
      }
    }  // RATE

    if (cRuleType=="MAX")
    {
      // find the default maximum for this type and check if it has changed
      decValue1 = parseFloat(document.getElementById("cMax").value);
      if (isNaN(decValue1)) decValue1 = 0.00;
      decValue2 = parseFloat(typeArray[iExpType].typeMax);
      if (isNaN(decValue2)) decValue2 = 0.00;
      if (decValue1 != decValue2)
      {
        oopFlag = true;
        if (cRuleMessage == "") cRuleMessage = "Claim over maximum (" + decValue2 + ") requires explanation";
        oopMess += "\n" + cRuleMessage;
      }
    }  // MAX

    if (cRuleType=="MAXPER")
    {
      // use the Params to find out which fields
      cParamArray = cRuleParams.split(",");
      decValue1 = parseFloat(document.getElementById(cParamArray[0]).value);
      if (isNaN(decValue1)) decValue1 = 0.00;
      decValue2 = parseFloat(document.getElementById(cParamArray[1]).value);
      if (isNaN(decValue2)) decValue2 = 0.00;

      decValue3 = parseFloat(document.getElementById("cMax").value);
      if (isNaN(decValue3)) decValue3 = 0.00;
      if ((decValue1/decValue2) > decValue3) // eg. Claimed Amount / Number of People > Max
      {
        oopFlag = true;
        // TODO: get Labels for the fields being compared
        if (cRuleMessage == "") cRuleMessage = cParamArray[0] + " over maximum per " + cParamArray[1];
        oopMess += "\n" + cRuleMessage;
      }
    } // MAXPER

    if (cRuleType=="COMPARE")
    {
      // use the Params to find out which fields
      cParamArray = cRuleParams.split(",");
      decValue1 = parseFloat(document.getElementById(cParamArray[0]).value);
      if (isNaN(decValue1)) decValue1 = 0.00;
      cOperator = cParamArray[1];
      decValue2 = parseFloat(document.getElementById(cParamArray[2]).value);
      if (isNaN(decValue2)) decValue2 = 0.00;

      if (cOperator==">")
      {
        if (decValue1>decValue2)
        {
          oopFlag = true;
        }
      }
      if (cOperator=="<")
      {
        if (decValue1<decValue2)
        {
          oopFlag = true;
        }
      }
      if (cOperator=="<=")
      {
        if (decValue1<=decValue2)
        {
          oopFlag = true;
        }
      }
      if (cOperator=="<>")
      {
        if (decValue1!=decValue2)
        {
          oopFlag = true;
        }
      }
      if (cOperator=="=")
      {
        if (decValue1==decValue2)
        {
          oopFlag = true;
        }
      }
      if (oopFlag)
      {
        // TODO: get Labels for the fields being compared
        if (cRuleMessage == "") cRuleMessage = cParamArray[0] + " " + cOperator + " " + cParamArray[2];
        oopMess += "\n" + cRuleMessage;
      }
    }  // COMPARE


  }

  if (oopFlag)
  {
    document.getElementById("cOOPReason_Row").style.display = "";
    document.getElementById("cOOPReason").focus();
    alert(oopMess);
  }
  else
  {
    document.getElementById("cOOPReason_Row").style.display = "none";
    document.getElementById("cOOPReason").value = "";
  }

  return oopFlag;
}

function showMap()
{
  var cFrom = document.getElementById("cFromLoc").value;
  var cTo = document.getElementById("cToLoc").value;
  var mapSrc="http://maps.google.co.uk/maps?saddr=";
  mapSrc+=cFrom
  mapSrc+="&daddr=" + cTo
  myMapWindow = window.open(mapSrc,"_eBISMap","width=800,height=600,resizable=yes,scrollbars=yes,menubar=yes,toolbar=yes");
}

function validateAndSave()
{
  var lError = checkPolicy();
  if (lError)
  {
    if (document.getElementById("cOOPReason").value != "")
    {
      alert("Saved with OOP Warnings");
    }
  }
  else
  {
    alert("Save OK");
  }
}

