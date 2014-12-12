Tiggr("myGrid tbody").empty(); // empty the grid; the default is one row from the builder 

var counter = 1; // keep track of our rows 

function gridInsertRow(title, expenseType, expenseReason, expenseAmount){ 
var newRowNum = counter ++; 
var html = "<tr id='GridAddRowObj_" + newRowNum + "'>"; 
    html += "<td style='margin: 0px 0px 0px 0px;'>" + "<font face='geordia' size='2' color='#236B8E'>" + title + "</font></td>";
    html += "<td align='center' style='margin: 0px 0px 0px 0px;'>" + "<font face='geordia' size='2' color='#236B8E'>" + expenseType + "</font></td>";
    html += "<td style='margin: 0px 0px 0px 0px;'>" + "<font face='geordia' size='2' color='#236B8E'>" + expenseReason + "</font></td>"; 
    html += "<td align='right' style='margin: 0px 0px 0px 0px;'>" + "<font face='geordia' size='2' color='#236B8E'>" + expenseAmount + "</font></td>";
    html += "<td style='margin: 0px 0px 0px 0px;'>" + " " + "</font></td>";
html += "<td><a href='#' onclick='gridDeleteRow(" + newRowNum + ");' data-role='button' data-icon='delete' data-iconpos='notext'>Delete</a></td>"; 
html += "</tr>"; 
Tiggr("myGrid").append(html); 
Tiggr("myGrid").trigger('create'); // for refreshing the controls so the JQuery Mobile styles will show up 
return false; 
} 

function gridDeleteRow(rowId) { 
console.log("gridDeleteRow: " + rowId); 
var rowTarget = "#GridAddRowObj_" + rowId; 
console.log("rowTarget: " + rowTarget); 
$(rowTarget).remove(); 
return false; 
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