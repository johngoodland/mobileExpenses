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