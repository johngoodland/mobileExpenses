// Code placed here is to do with the startup of the app


// hardcode json dataset for the localSettings will be changed to read later, but for now I'm just gettings it from local storage

var localSettings = localStorage.getItem("localSettings");
if (!localSettings) 
{
  localSettings = [];
  var item = 
  {
    "ConnectServer": "Always - roaming costs could occur",
    "Mileage": "Always - roaming costs could occur",
    "Cache": "Never",
    "UserID": "MPH",
    "Network": "http://ebismobile.no-ip.net:8980" ,
    "NetKey": "123",
    "Account": "Active",
    "Sync": "Always (Roaming costs could occur)",
    "SyncDate": "03/11/2012"                
  };
  localSettings.push(item);  
  myJSON = JSON.stringify({localSettings: localSettings});  
  localStorage.setItem("localSettings", myJSON);
}
// need to write a parser to pass in name and it returns value, no point storing all these in another storage area.

function setLocalSettings (setting, value)
{   
var data = localStorage.getItem("localSettings");
var parsedTypes = JSON.parse(data);
var JSONTypes = JSON.stringify(parsedTypes.localSettings);
if (setting == "ConnectServer")
  {  parsedTypes.localSettings[0].ConnectServer = value; }
if (setting == "Mileage")
  {  parsedTypes.localSettings[0].Mileage = value; }
if (setting == "Cache")
  {  parsedTypes.localSettings[0].Cache = value; }
if (setting == "UserID")
  {  parsedTypes.localSettings[0].UserID = value; }
if (setting == "Network")
  {  parsedTypes.localSettings[0].Network = value; }
if (setting == "NetKey")
  {  parsedTypes.localSettings[0].NetKey = value; }
if (setting == "Account")
  {  parsedTypes.localSettings[0].Account = value; }
if (setting == "Sync")
  {  parsedTypes.localSettings[0].Sync = value; }
if (setting == "SyncDate")
  {  parsedTypes.localSettings[0].SyncDate = value; }   
localStorage.setItem("localSettings", JSON.stringify(parsedTypes));
 
}
