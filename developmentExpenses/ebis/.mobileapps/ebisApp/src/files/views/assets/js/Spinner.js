function spinnerTop(screen,text) {
// Use for restservice indicator. Ensure remove on Complete and Fail...
//Sets spinner top right. Over Top of Header if there.. Header Z-index is 1000
// Styles applied to Tiggzi page name
var cssContent = {'position':'absolute','right':'10px','width':'60','height':'30','top':'4px','z-index':'2000'};
//Sets text over added spinner
var textStyles1 = {'text-align':'center','position':'absolute','color':'white','font-weight':'bold','font-size':'12px','top':'0px','z-index':'2002'};
$('<div class="SpinnerAdd" align="center"><div></div><div></div><div></div></div>').prependTo(Tiggzi(screen)).css(cssContent);
$('<p>').appendTo($('.SpinnerAdd')).text(text).css(textStyles1);
// To Remove... Use $('.SpinnerAdd').remove();
}

function spinnerFull(screen,text) {
//FULL SCREEN Ajax spinner... Disables entitre screen and centers loader gif
//Sets Background opacity, size etc.
var cssBack = {'background-color':'white','opacity':'0.3','width':'320','height':'470','top':'0px','position':'absolute','z-index':'2000'};
//Sets Spinner
//var Spinner = {'position':'absolute','right':'45%','top':'50%','z-index':'2002'};
$('<div class="Backdrop"/>').prependTo(Tiggzi(screen)).css(cssBack);
//$('<div class="SpinnerAdd" align="center"><div></div><div></div><div></div></div>').prependTo(Tiggzi(screen)).css(Spinner);
//Optional message on Full Screen Spinner
if (text != null) {	
var textStyles2 = {'text-align':'center','position':'absolute','color':'white','font-weight':'bold','font-size':'12px','top':'0px','z-index':'2004'};
$('<p>').appendTo($('.SpinnerAddFull')).text(text).css(textStyles2);
}
// To Remove... Use $('.SpinnerAdd').remove(); AND $('.Backdrop').remove();
}