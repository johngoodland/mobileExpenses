/*
 * JS for home generated by Tiggzi
 *
 * Created on: Thursday, April 18, 2013, 03:54:40 AM (PDT)
 */
/************************************
 * JS API provided by Exadel Tiggzi  *
 ************************************/
/* Setting project environment indicator */
Tiggzi.env = "bundle";
Tiggzi.getProjectGUID = function() {
    return '203b3706-91d6-47ce-93cd-9dfecc81b958';
}
Tiggzi.getTargetPlatform = function() {
    return '0';
}

function navigateTo(outcome, useAjax) {
    Tiggzi.navigateTo(outcome, useAjax);
}

function adjustContentHeight() {
    Tiggzi.adjustContentHeight();
}

function adjustContentHeightWithPadding() {
    Tiggzi.adjustContentHeightWithPadding();
}

function setDetailContent(pageUrl) {
    Tiggzi.setDetailContent(pageUrl);
}
/**********************
 * SECURITY CONTEXTS  *
 **********************/
/*******************************
 *      SERVICE SETTINGS        *
 ********************************/
/*************************
 *      SERVICES          *
 *************************/
var CameraService = new Tiggr.CameraService({});
var ContactsService = new Tiggr.ContactsService({});
createSpinner("files/resources/lib/jquerymobile/images/ajax-loader.gif");
Tiggzi.AppPages = [{
    "name": "home",
    "location": "#j_0"
}];
j_0_js = function(runBeforeShow) { /* Object & array with components "name-to-id" mapping */
    var n2id_buf = {
        'mobileimage_4': 'j_4',
        'btnTakePicture': 'j_5',
        'mobilebutton1_6': 'j_6'
    };
    if ("n2id" in window && window.n2id !== undefined) {
        $.extend(n2id, n2id_buf);
    } else {
        window.n2id = n2id_buf;
    }
    Tiggr.CurrentScreen = 'j_0';
    /*************************
     * NONVISUAL COMPONENTS  *
     *************************/
    var datasources = [];
    mobilecamera1 = new Tiggr.DataSource(CameraService, {
        'onComplete': function(jqXHR, textStatus) {
            $t.refreshScreenFormElements("j_0");
        },
        'onSuccess': function(data) {},
        'onError': function(jqXHR, textStatus, errorThrown) {},
        'responseMapping': [{
            'PATH': ['imageDataBase64'],
            'ID': 'mobileimage_4',
            'ATTR': 'src'
        }],
        'requestMapping': [{
            'PATH': ['quality'],
            'ATTR': '80'
        }, {
            'PATH': ['destinationType'],
            'ATTR': 'Data URL'
        }, {
            'PATH': ['sourcetype'],
            'ATTR': 'Photolibrary'
        }, {
            'PATH': ['allowedit'],
            'ATTR': 'true'
        }, {
            'PATH': ['encodingType'],
            'ATTR': 'JPEG'
        }, {
            'PATH': ['targetWidth'],
            'ATTR': '1024'
        }, {
            'PATH': ['targetHeight'],
            'ATTR': '768'
        }]
    });
    datasources.push(mobilecamera1);
    mobilecamera2 = new Tiggr.DataSource(CameraService, {
        'onComplete': function(jqXHR, textStatus) {
            $t.refreshScreenFormElements("j_0");
        },
        'onSuccess': function(data) {},
        'onError': function(jqXHR, textStatus, errorThrown) {},
        'responseMapping': [{
            'PATH': ['imageDataBase64'],
            'ID': 'mobileimage_4',
            'ATTR': 'src'
        }],
        'requestMapping': [{
            'PATH': ['quality'],
            'ATTR': '80'
        }, {
            'PATH': ['destinationType'],
            'ATTR': 'Data URL'
        }, {
            'PATH': ['sourcetype'],
            'ATTR': 'Photolibrary',
            'TRANSFORMATION': function(value) {
                return "camera"
            }
        }, {
            'PATH': ['allowedit'],
            'ATTR': 'true'
        }, {
            'PATH': ['encodingType'],
            'ATTR': 'JPEG'
        }, {
            'PATH': ['targetWidth'],
            'ATTR': '1024'
        }, {
            'PATH': ['targetHeight'],
            'ATTR': '768'
        }]
    });
    datasources.push(mobilecamera2);
    // Tiggzi Push-notification registration service
    /************************
     * EVENTS AND HANDLERS  *
     ************************/
    j_0_beforeshow = function() {
        Tiggzi.CurrentScreen = 'j_0';
        for (var idx = 0; idx < datasources.length; idx++) {
            datasources[idx].__setupDisplay();
        }
    }
    // screen onload
    screen_12CF_onLoad = j_0_onLoad = function() {
        screen_12CF_elementsExtraJS();
        j_0_windowEvents();
        screen_12CF_elementsEvents();
    }
    // screen window events
    screen_12CF_windowEvents = j_0_windowEvents = function() {
        $('#j_0').bind('pageshow orientationchange', function() {
            adjustContentHeightWithPadding();
        });
    }
    // screen elements extra js
    screen_12CF_elementsExtraJS = j_0_elementsExtraJS = function() {
        // screen (screen-12CF) extra code
    }
    // screen elements handler
    screen_12CF_elementsEvents = j_0_elementsEvents = function() {
        $("a :input,a a,a fieldset label").live({
            click: function(event) {
                event.stopPropagation();
            }
        });
        $('#j_3 [name="btnTakePicture"]').die().live({
            click: function() {
                if (!$(this).attr('disabled')) {
                    try {
                        mobilecamera1.execute({})
                    } catch (ex) {
                        console.log(ex.name + '  ' + ex.message);
                        hideSpinner();
                    };
                }
            },
            tap: function() {
                try {
                    mobilecamera1.execute({})
                } catch (ex) {
                    console.log(ex.name + '  ' + ex.message);
                    hideSpinner();
                };
            },
        });
        $('#j_3 [name="mobilebutton1_6"]').die().live({
            click: function() {
                if (!$(this).attr('disabled')) {
                    try {
                        mobilecamera2.execute({})
                    } catch (ex) {
                        console.log(ex.name + '  ' + ex.message);
                        hideSpinner();
                    };
                }
            },
            tap: function() {
                try {
                    mobilecamera2.execute({})
                } catch (ex) {
                    console.log(ex.name + '  ' + ex.message);
                    hideSpinner();
                };
            },
        });
    }
    $("#j_0").die("pagebeforeshow").live("pagebeforeshow", function(event, ui) {
        j_0_beforeshow();
    });
    if (runBeforeShow) {
        j_0_beforeshow();
    } else {
        j_0_onLoad();
    }
}
$("#j_0").die("pageinit").live("pageinit", function(event, ui) {
    Tiggzi.processSelectMenu($(this));
    j_0_js();
});