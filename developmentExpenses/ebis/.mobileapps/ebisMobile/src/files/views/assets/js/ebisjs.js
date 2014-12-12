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