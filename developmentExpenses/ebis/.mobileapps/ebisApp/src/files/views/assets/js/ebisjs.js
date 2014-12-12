window.onorientationchange = function() 
{ 
            //Need at least 800 milliseconds
  setTimeout(changeOrientation, 1000);
}

    
var toastDelay = 2000;
function toast(sMessage,size) {

var container = $(document.createElement("div"));
container.addClass("toast");
var message = $(document.createElement("div"));
message.addClass("message");
message.text(sMessage);
message.appendTo(container);
if ($('.message').length) {
var screenSize = $(document).height();
var p = $('.message:last');
var position = p.offset();
var it = (position.top);
position = screenSize - it;
position = position + 4;
container.appendTo(document.body).css({'bottom':position,'font-size':size});
}else{
container.appendTo(document.body).css({'font-size':size});
}
container.delay(100).fadeIn("slow", function() {
$(this).delay(toastDelay).slideUp("slow", function() {
$(this).remove();
});
}); 

$('.message').click( function() {
$('.message:first').remove();
});

}//end function 

var portraitScreenHeight;
var landscapeScreenHeight;

if(window.orientation === 0 || window.orientation === 180){
potraitScreenHeight = $(window).height();
landscapeScreenHeight = $(window).width();
}
else{
portraitScreenHeight = $(window).width();
landscapeScreenHeight = $(window).height();
}
var tolerance = 25;
$(window).bind('resize', function(){
if((window.orientation === 0 || window.orientation === 180) &&
((window.innerHeight + tolerance) < portraitScreenHeight)){
$("[data-role=footer]").hide();
}
else if((window.innerHeight + tolerance) < landscapeScreenHeight){
$("[data-role=footer]").hide();
}
else{
$("[data-role=footer]").show();
}
});


function changeOrientation(){
switch(window.orientation) {
case 0: // portrait, home bottom
case 180: // portrait, home top 
 $('td:nth-child(4)').css('width', '0px');
 $('td:nth-child(2)').css('width', '40%');
 $('td:nth-child(1)').css('width', '45%');
 $('td:nth-child(3)').css('width', '8%');
 $('td:nth-child(4)').hide();
 break;
      case -90: // landscape, home left
      case 90: // landscape, home right

      $('td:nth-child(4)').css('width', 'auto');
      $('td:nth-child(3)').css('width', '8%');
      $('td:nth-child(2)').css('width', '40%');
      $('td:nth-child(1)').css('width', '45%');
      $('td:nth-child(4)').show();
      break;
        }
    }



function createUUID() {
    // http://www.ietf.org/rfc/rfc4122.txt
    var s = [];
    var hexDigits = "0123456789abcdef";
    for (var i = 0; i < 36; i++) {
        s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
    }
    s[14] = "4";  // bits 12-15 of the time_hi_and_version field to 0010
    s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1);  // bits 6-7 of the clock_seq_hi_and_reserved to 01
    s[8] = s[13] = s[18] = s[23] = "-";

    var uuid = s.join("");
    return uuid;
}
function deleteUnsent() 
{
  console.log('Reading expense form data extracting unsent lines to delete.');
  Tiggzi('buttoneBIS').removeClass('animated pulse');
  var theid =  "Unsent"; // looking for unsent only 
  var expenseForm = localStorage.getItem("expenseRaw");
  if (!expenseForm) 
  {
    expenseForm = [];
  } else 
  {
	expenseForm = JSON.parse(expenseForm);
  }
  var parsedFields = JSON.parse(localStorage.getItem("expenseForm"));
  var JSONFields = JSON.stringify(parsedFields.expenseForm);
  var parsed = JSON.parse(JSONFields);
  
  for(var i = parsed.length - 1; i >= 0; i--) 
  {
    if (theid == parsed[i].expenseStatus)
    {
      parsed.splice(i, 1);
    }
  }
 
  myJSON = JSON.stringify({expenseForm: parsed});
  localStorage.setItem('SendCounter', 0);
  localStorage.setItem("expenseForm", myJSON); 
  localStorage.setItem("expenseRaw", JSON.stringify(parsed));
  showMenuCounters();
}
function gridClaimDelete() 
{
  console.log('Reading expense form data extracting line to delete.');
  Tiggzi('buttoneBIS').removeClass('animated pulse');
  var theid =  localStorage.getItem("lv_tagId") ;  
  if (theid !== "")
  {
    var expenseForm = localStorage.getItem("expenseRaw"); //convert back to a Javascript object
    if (!expenseForm) 
    {
      expenseForm = [];
    } else 
    {
      expenseForm = JSON.parse(expenseForm);
    }
	var parsed = expenseForm;
    
    for (var i = 0; i < parsed.length; ++i)
      
      if (theid == parsed[i].expense_ID)
      {
        console.log('Found data to delete.');
        expenseForm.splice(i,1);
        var Counter = isNaN(parseInt(localStorage.getItem('SendCounter'))) ? 0 : parseInt(localStorage.getItem('SendCounter'));
        Counter--;
        localStorage.setItem('SendCounter', Counter);
        myJSON = JSON.stringify({expenseForm: expenseForm});
        localStorage.setItem("expenseForm", myJSON); 
        localStorage.setItem("expenseRaw", JSON.stringify(expenseForm));
        showMenuCounters();
      }
  }
}

function gridFavDelete() 
{
  console.log('Reading fav form data extracting line to delete.');
  
  var theid =  localStorage.getItem("lv_favtagId") ;  
  if (theid !== "")
  {
    var favForm = localStorage.getItem("favRaw"); //convert back to a Javascript object
    if (!favForm) 
    {
      favForm = [];
    } else 
    {
      favForm = JSON.parse(favForm);
    }
	var parsed = favForm;
    
    for (var i = 0; i < parsed.length; ++i)
      
      if (theid == parsed[i].Fav_ID)
      {
        console.log('Found Fav data to delete.');
        favForm.splice(i,1);
        myJSON = JSON.stringify({favForm: favForm});
        localStorage.setItem("favForm", myJSON); 
        localStorage.setItem("favRaw", JSON.stringify(favForm));
         
      }
  }
}

function filterById(jsonObject, id) {return jsonObject.filter(function(jsonObject) {return (jsonObject['expense_ID'] == id);})[0];}
if (!Array.prototype.filter)
{
  Array.prototype.filter = function(fun /*, thisp */)
  {
    "use strict";
 
    if (this == null)
      throw new TypeError();
 
    var t = Object(this);
    var len = t.length >>> 0;
    if (typeof fun != "function")
      throw new TypeError();
 
    var res = [];
    var thisp = arguments[1];
    for (var i = 0; i < len; i++)
    {
      if (i in t)
      {
        var val = t[i]; // in case fun mutates this
        if (fun.call(thisp, val, i, t))
          res.push(val);
      }
    }
 
    return res;
  };
}
function miles()
{
    
  var miles = (Tiggzi("cExpClaimMiles").val());
  var rate  = (Tiggzi("cExpType").val());  
  rate = 0.45;
  
      if (miles !== "" && rate !== "") {
          var FormattedMoney = formatMoney(miles * rate);
          Tiggzi('cExpAmount').val(FormattedMoney);
      }


}
function formatGBP(num) {
    var p = num.toFixed(2).split(".");
    return p[0].split("").reverse().reduce(function(acc, num, i, orig) {
        return  num + (i && !(i % 3) ? "," : "") + acc;
    }, "") + "." + p[1];
}
function formatDollar(num) {
    var p = num.toFixed(2).split(".");
    return "$" + p[0].split("").reverse().reduce(function(acc, num, i, orig) {
        return  num + (i && !(i % 3) ? "," : "") + acc;
    }, "") + "." + p[1];
}
function formatMoney (n) { 
var c = 2, /*decimals count*/ 
d = ".",/*decimal separator*/ 
t = ",", /*thousands separator*/ 
s = n < 0 ? "-" : "", 
i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", 
j = (j = i.length) > 3 ? j % 3 : 0; 
return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : ""); 
}; 
 
function ebisExecuteServices () 
{
 var theid =  localStorage.getItem("lv_tagId") ;  
 
 if (theid == "copy")
 { try 
    {
      FavJSONread.execute({});
    } catch (ex) 
    {
      console.log(ex.name + '  ' + ex.message);
      hideSpinner();
    };
 }
 else
 {  try 
    {
      ExpenseJSONread.execute({});
    } catch (ex) 
    {
      console.log(ex.name + '  ' + ex.message);
      hideSpinner();
    };
 }
}

function ebisExecuteCamera ()
{
  try {
       mobilecamera1.execute({})
      } catch (ex) 
      {
        console.log(ex.name + '  ' + ex.message);
        hideSpinner();
      };   
}
/*
Removed as we decided camera would only be run on button click not on page init
function ebisExecuteServicesOLD () 
{
 var theid =  localStorage.getItem("lv_tagId") ;  
 
 if (theid == "")
 {
   try {
        mobilecamera1.execute({})
        } catch (ex) {
            console.log(ex.name + '  ' + ex.message);
            hideSpinner();
        };
   try {
        ExpenseJSONread.execute({});
        } catch (ex) {
            console.log(ex.name + '  ' + ex.message);
            hideSpinner();
        };

 }
 else
 {
   try {
        ExpenseJSONread.execute({});
        } catch (ex) {
            console.log(ex.name + '  ' + ex.message);
            hideSpinner();
        };
 }
 
}
*/

function ebisDeleteLine()
{
    alert("in delete");
 // mycomments.comments.splice(5,1);   
}
 
function changeButtonType(buttonType)
{
 if (buttonType == "Cancel") 
 {
   $("a[dsid='mobilebutton_reject'] .ui-btn-text").text(buttonType);
   $("[name=mobilebutton_reject]").css('color','white');
   $("[name=mobilebutton_reject]").css('text-shadow','0 -1px 1px #711414');
   $("[name=mobilebutton_reject]").css('background-image','-moz-linear-gradient(top, #DADADA, #343438)');
   $("[name=mobilebutton_reject]").css('background-image','-webkit-gradient(linear, left top, left bottom, color-stop(0, #DADADA), color-stop(1, #343438))');  
   $("[name=mobilebutton_reject]").css('-ms-filter', "progid:DXImageTransform.Microsoft.gradient(startColorStr='#DADADA', EndColorStr='#343438')"); 
 }
 else
 {
   $("a[dsid='mobilebutton_reject'] .ui-btn-text").text(buttonType);
   $("[name=mobilebutton_reject]").css('background-image','-moz-linear-gradient(top, #c45e5e, #9e3939)');
   $("[name=mobilebutton_reject]").css('background-image','-webkit-gradient(linear, left top, left bottom, color-stop(0, #c45e5e), color-stop(1, #9e3939))');  
   $("[name=mobilebutton_reject]").css('-ms-filter', "progid:DXImageTransform.Microsoft.gradient(startColorStr='#c45e5e', EndColorStr='#9e3939')");   
 }
}
function getMiles()
{
  showSpinner({text: 'Calculating Mileage...', textVisible:true, theme: 'a'} ); 
  var mapURL="https://dev.virtualearth.net/REST/V1/Routes/Driving";
  mapURL += "?o=json";
  mapURL += "&wp.0="+localStorage.getItem('myStartPostcode');
  mapURL += "&wp.1="+localStorage.getItem('myEndPostcode');
  mapURL += "&distanceUnit=mi";
  mapURL += "&key=Aqo0rRIuVf2DX9Y898Rl3L61hcQuDkUL_Acr9y02gEbRlckR32mGHLzP_JnYVWOE";
  //prompt("mapURL",mapURL);
  //document.getElementById("myJSONURL").value=mapURL;
  getMilesViaJSONP(mapURL);
 
}

function getMilesViaJSONP(mapURL)
{
  // creates a script to include the JSON as if it was a JS file and get around the Cross Site restrictions
  var s = document.createElement("script");
  s.src = mapURL + "&jsonp=parseResponse";
  s.type = "text/javascript";
  document.getElementsByTagName("head")[0].appendChild(s);
    
}
 
function parseResponse(myJSON)
{ 
    var statusCode = (myJSON.statusCode);
    if (statusCode == '200')
    {
      Tiggzi('cExpCalcMiles').val(myJSON.resourceSets[0].resources[0].travelDistance.toFixed(2));
      Tiggzi('cExpClaimMiles').val(myJSON.resourceSets[0].resources[0].travelDistance.toFixed(2));
      miles();
    }
    else
    {
      toastDelay = 4000;//message show time
      toast(myJSON.errorDetails[0] + "(" + myJSON.errorDetails[1] + ")");
    }
    hideSpinner({});
}

function ebisConnection()
{
 
  var settings;
  var settingsURL;
  var catalogURL;
  var cMsg = "ok";
  showSpinner({text: 'Please Wait...', textVisible:true, theme: 'b'} ); 
  try 
  {
  /* CHANGE THIS TO POINT TO YOUR SETTINGS SERVICE */ 
    settings = ebisService_eBISdata_Settings;
    settingsURL =  localStorage.getItem("ServerIPAddress") + settings.serviceURL ;  
    catalogURL =  localStorage.getItem("ServerIPAddress") + settings.catalogURL;  
  
    pdsession = new progress.data.Session();
    var loginResult = pdsession.login(settingsURL,"","");
    if (loginResult != progress.data.Session.LOGIN_SUCCESS) 
    {
      console.log('ERROR: Login failed with code: ' + loginResult);
      switch (loginResult) 
      {
        case progress.data.Session.LOGIN_AUTHENTICATION_FAILURE:
        cMsg = 'Invalid user-id or password';
        break;
        case progress.data.Session.LOGIN_GENERAL_FAILURE:
        default:
        cMsg = 'Service is unavailable';
        break;
      }
    }
  }
  catch (e) 
  {
    cMsg = "Failed to log in";
    console.log(e.stack);
  }
  if (cMsg != "ok") 
  {
    toastDelay = 4000;//message show time
    toast(cMsg);
    return;
  }
  pdsession.addCatalog(catalogURL);
  ebisInvokeTransfer();
}
//start transfer to ebis
function ebisInvokeTransfer() 
{
 try {
      ebisInitObject.execute({})
     }
     catch (ex) 
     {
       console.log(ex.name + '  ' + ex.message);           
     };
 try {
     ebisCaptureExpense.execute({})
     } 
     catch (ex) 
     {
       console.log(ex.name + '  ' + ex.message);
              
     };
  hideSpinner({});
}

//Call this function on Page show event
function showMenuCounters() 
{
//shows counts over Menu screen Icons
  $('#jobscount').remove();
  $('#Warning').remove();
  var counter = localStorage.getItem('SendCounter');
  var ResultData = localStorage.getItem("ResultGroups");
  if (counter > 0) 
  {
    setTimeout(function() {displayCounters();},1000);
  }
  else
  {
  $('#jobscount').remove();//Remove any existing Jobs counter style first
  }
  if (!ResultData)
  {
    setTimeout(function() {displayWarnings();},1000);  
  }
  else
  {
    $('#Warning').remove();
  }
    
}
function displayCounters() 
{
  var counter = localStorage.getItem('SendCounter');
  var jobsdo = Tiggzi('buttoneBIS'); //get Div of Jobs Pic
  var sendjobsdo = Tiggzi('mobilelistitem_252');
  var warningSync = Tiggzi('mobilelistitem_254');
  $('#jobscount').remove();//Remove any existing Jobs counter style first
  $('#Warning').remove();//Remove any existing warning counter style first
//  var StyleTask = {'text-align': 'center', 'position':'absolute', 'color': 'white', 'text-shadow': '10px 10px 1px #000', 'font-weight': 'bold', 'font-size': '100%', 'margin-left':'15px','margin-top':'-15px'};
//  var StyleJob = {'text-align': 'center', 'position':'absolute', 'color': 'red', 'text-shadow': '8px 8px 1px #000', 'font-weight': 'bold', 'margin-left':'22px','margin-top':'-30px'};
 // var StyleJob1 = {'text-align': 'center', 'position':'absolute', 'color': 'red', 'text-shadow': '8px 8px 1px #000', 'font-weight': 'bold', 'margin-left':'18px','margin-top':'-34px'};
  var StyleJob = {'padding': '2px', 'background-color':'red', 'position':'absolute', 'color': 'white', 'font-weight': 'bold', 'margin-left':'22px','margin-top':'-30px','vertical-align':'middle', '-moz-border-radius':'10px', 'border-radius':'10px'};
  var StyleJob1 = {'padding': '1px', 'background-color':'red', 'position':'absolute', 'color': 'white', 'font-weight': 'bold', 'margin-left':'22px','margin-top':'-37px','vertical-align':'middle', '-moz-border-radius':'10px', 'border-radius':'10px'};
 
  if (counter > 0 )
  {
    $('<p id="jobscount">').appendTo(jobsdo).text(counter).css(StyleJob);
    Tiggzi('buttoneBIS').addClass('animated pulse');
    $('<p id="jobscount">').appendTo(sendjobsdo).text(counter).css(StyleJob1);
  }

}
function displayWarnings()
{
  var jobsdo = Tiggzi('buttoneBIS'); //get Div of Jobs Pic
  var warningSync = Tiggzi('mobilelistitem_286');
  $('#Warning').remove();//Remove any existing warning counter style first
  var StyleTask = {'text-align': 'center', 'position':'absolute', 'color': 'white', 'text-shadow': '10px 10px 1px #000', 'font-weight': 'bold', 'font-size': '100%', 'margin-left':'15px','margin-top':'-15px'};
    var StyleJob = {'padding': '2px', 'background-color':'red', 'position':'absolute', 'color': 'white', 'font-weight': 'bold', 'margin-left':'10px','margin-top':'-30px','font-size':'150%','vertical-align':'middle', '-moz-border-radius':'10px', 'border-radius':'10px'};
  var StyleJob1 = {'padding': '1px', 'background-color':'red', 'position':'absolute', 'color': 'white', 'font-weight': 'bold', 'margin-left':'10px','margin-top':'-35px','font-size':'150%','vertical-align':'middle', '-moz-border-radius':'10px', 'border-radius':'10px'};
  $('<p id="Warning">').appendTo(warningSync).text("!").css(StyleJob1);   
  $('<p id="jobscount">').appendTo(jobsdo).text("!").css(StyleJob);
 
}
function checkConnectionType()
{
document.addEventListener("deviceready", onDeviceReady, false);

    // Cordova is loaded and it is now safe to make calls Cordova methods
    //
    function onDeviceReady() {
        checkConnection();
    }

    function checkConnection() {
        var networkState = navigator.connection.type;

        var states = {};
        states[Connection.UNKNOWN]  = 'Unknown connection';
        states[Connection.ETHERNET] = 'Ethernet connection';
        states[Connection.WIFI]     = 'WiFi connection';
        states[Connection.CELL_2G]  = 'Cell 2G connection';
        states[Connection.CELL_3G]  = 'Cell 3G connection';
        states[Connection.CELL_4G]  = 'Cell 4G connection';
        states[Connection.NONE]     = 'No network connection';

        //alert('Connection type: ' + states[networkState]);
        Tiggzi('mobileConnectionType').val(states[networkState]);
    }  
}
 
function MilesFormDone ()
{
  localStorage.setItem('lv_mobileDate',Tiggzi('mobileDate').val());
  localStorage.setItem('lv_mobileType',"Mileage");
  localStorage.setItem('lv_mobileReason',Tiggzi('mobileReason').val());
  localStorage.setItem('lv_mobileAmount',Tiggzi('mobileAmount').val());
  localStorage.setItem('lv_mobileNotes',Tiggzi('mobileNotes').val());
  localStorage.setItem('lv_mobileMilesClaim',Tiggzi('mobileMiles').val());
  localStorage.setItem('lv_mobileMilesRate',Tiggzi('mobileRate').val());
  localStorage.setItem('lv_mobileFrom',Tiggzi('mobileFrom').val());
  localStorage.setItem('lv_mobileTo',Tiggzi('mobileTo').val());
  
  try 
  {
    ExpenseJSONWrite_miles.execute({})
  } catch (ex) 
  {
    console.log(ex.name + '  ' + ex.message);
  };    
 
  var isFav =  localStorage.getItem("FavExpense") ;  
  // If fav then write data 
  if (isFav == "yes")
  {
    try 
    {
      FavJSONWrite_miles.execute({})
    } catch (ex) 
    {
      console.log(ex.name + '  ' + ex.message);
      hideSpinner();
    }
  };
}
function ReceiptFormDone ()
{
  /* set local storage then clear screen input */
  localStorage.setItem('lv_mobileGroup',localStorage.getItem('sessionGroup'));
  localStorage.setItem('lv_mobileDate',Tiggzi('cExpDate').val());
  localStorage.setItem('lv_mobileType',Tiggzi('cExpType').val());
  localStorage.setItem('lv_mobileReason',Tiggzi('cExpReason').val());
  localStorage.setItem('lv_mobileAmount',Tiggzi('cExpAmount').val());
  localStorage.setItem('lv_mobileNotes',Tiggzi('cExpReason').val());
  localStorage.setItem('lv_mobileMilesClaim',Tiggzi('cExpClaimMiles').val());
  localStorage.setItem('lv_mobileMilesRate',Tiggzi('cExpCalcMiles').val());
  localStorage.setItem('lv_mobileFrom',Tiggzi('cExpFrom').val());
  localStorage.setItem('lv_mobileTo',Tiggzi('cExpTo').val());
  localStorage.setItem('lv_mobileCharge',Tiggzi('cExpCharge').val()); 
  localStorage.setItem('lv_mobilePurpose',Tiggzi('cExpPurpose').val()); 
  localStorage.setItem('lv_mobileOOP',Tiggzi('cExpOOP').val()); 
  localStorage.setItem('lv_mobilePayee',Tiggzi('cExpPayee').val()); 
  localStorage.setItem('lv_mobileNoPeople',Tiggzi('cExpNoPeople').val()); 
  localStorage.setItem('lv_mobileNoNights',Tiggzi('cExpNoNights').val()); 
  localStorage.setItem('lv_mobileEveMeal',Tiggzi('cExpEveMeal').val()); 
  localStorage.setItem('lv_mobileBreak',Tiggzi('cExpBreak').val());
  localStorage.setItem('lv_mobileLunch',Tiggzi('cExpLunch').val()); 
  localStorage.setItem('lv_mobileVisit',Tiggzi('cExpVisit').val()); 
  localStorage.setItem('lv_mobileRound',Tiggzi('cExpRound').val()); 
  localStorage.setItem('lv_mobileVehicle',Tiggzi('cExpVehicle').val()); 
  localStorage.setItem('lv_mobileYTDMiles',Tiggzi('cExpYTDMiles').val()); 
  localStorage.setItem('lv_mobilePeople',Tiggzi('cExpPeople').val()); 
  Tiggzi('cExpReason').val("");
  Tiggzi('cExpAmount').val("");
  Tiggzi('cExpReason').val("");
  Tiggzi('cExpClaimMiles').val("");
  Tiggzi('cExpCalcMiles').val("");
  Tiggzi('cExpFrom').val("");
  Tiggzi('cExpTo').val("");  
  Tiggzi('cExpCharge').val("");
  Tiggzi('cExpPurpose').val("");
  Tiggzi('cExpOOP').val("");
  Tiggzi('cExpPayee').val("");
  Tiggzi('cExpNoPeople').val("");
  Tiggzi('cExpEveMeal').val("");
  Tiggzi('cExpBreak').val("");   
  Tiggzi('cExpLunch').val("");
  Tiggzi('cExpVisit').val("");
  Tiggzi('cExpRound').val("");
  Tiggzi('cExpVehicle').val("");
  Tiggzi('cExpYTDMiles').val("");
  Tiggzi('cExpPeople').val("");   
  /* build json dataset */
  try 
  { 
    ExpenseJSONWrite.execute({})
  } catch (ex) 
  {
    console.log(ex.name + '  ' + ex.message);
  };    
 
  var isFav =  localStorage.getItem("FavExpense") ;  
  // If fav then build local json data
  if (isFav == "yes")
  {
    try 
    {
      FavJSONWrite.execute({})
    } catch (ex) 
    {
      console.log(ex.name + '  ' + ex.message);
      hideSpinner();
    }
  };
}
function sortJSON(data, key, way) {
    return data.sort(function(a, b) {
        var x = a[key]; var y = b[key];
        if (way === '123' ) { return ((x < y) ? -1 : ((x > y) ? 1 : 0)); }
        if (way === '321') { return ((x > y) ? -1 : ((x < y) ? 1 : 0)); }
    });
}