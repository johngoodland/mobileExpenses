/*
 * JS for home generated by Tiggzi
 *
 * Created on: Friday, April 19, 2013, 03:19:20 AM (PDT)
 */
/************************************
 * JS API provided by Exadel Tiggzi  *
 ************************************/
/* Setting project environment indicator */
Tiggzi.env = "bundle";
Tiggzi.getProjectGUID = function() {
    return '6f7cd2db-6ae8-4f5e-926f-856ba5f752b0';
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
var Settings = {}
var ebisService_eBISdata_Settings = {
    "catalogURI": "http://10.9.32.117:8980/ebisService/static/mobile/ebisService.json",
    "ServiceURI": "http://10.9.32.117:8980/ebisService",
    "resourceName": "eBISdata"
}
/*************************
 *      SERVICES          *
 *************************/
ebisService_eBISdata_JSDO = new Tiggr.JSDO({
    'serviceSettings': ebisService_eBISdata_Settings
});
ebisService_eBISdata_eeBis_Update = new Tiggr.JSDOUpdate({
    'service': ebisService_eBISdata_JSDO,
    'tableName': 'eeBis'
});
ebisService_eBISdata_Read = new Tiggr.JSDORead({
    'service': ebisService_eBISdata_JSDO,
    'tableName': 'eeBis'
});
ebisService_eBISdata_CaptureExpenses = new Tiggr.JSDOInvoke({
    'service': ebisService_eBISdata_JSDO,
    'methodName': 'CaptureExpenses'
});
ebisService_eBISdata_eeBis_Delete = new Tiggr.JSDODelete({
    'service': ebisService_eBISdata_JSDO,
    'tableName': 'eeBis'
});
ebisService_eBISdata_eeBis_Create = new Tiggr.JSDOCreate({
    'service': ebisService_eBISdata_JSDO,
    'tableName': 'eeBis'
});
ebisService_eBISdata_eeBis_Row = new Tiggr.JSDORow({
    'service': ebisService_eBISdata_JSDO,
    'tableName': 'eeBis'
});
var RESTService = new Tiggr.RestService({
    'url': '',
    'dataType': 'json',
    'type': 'get',
});
GenericService = new Tiggr.GenericService({});
var CameraService = new Tiggr.CameraService({});
createSpinner("files/resources/lib/jquerymobile/images/ajax-loader.gif");
Tiggzi.AppPages = [{
    "name": "ebisMileageExpense",
    "location": "#j_0"
}, {
    "name": "ebisCameraExpense",
    "location": "#j_42"
}, {
    "name": "home",
    "location": "#j_69"
}, {
    "name": "grid_test",
    "location": "#j_96"
}];
j_69_js = function(runBeforeShow) { /* Object & array with components "name-to-id" mapping */
    var n2id_buf = {
        'mobilebutton1_4': 'j_70',
        'buttonAdd': 'j_71',
        'myGrid': 'j_72',
        'mobilegridcell_40': 'j_73',
        'mobilegridcell_44': 'j_74',
        'mobilegridcell_46': 'j_75',
        'mobilegridcell_48': 'j_76',
        'mobilegridcell_49': 'j_77',
        'mobilegridcell_50': 'j_78',
        'mobilegrid_51': 'j_79',
        'mobilegridcell_52': 'j_80',
        'mobilegroupedbuttons1_38': 'j_81',
        'mobileDelete': 'j_82',
        'mobileUpload': 'j_83',
        'mobileCancel_1': 'j_84',
        'mobilebuttonsCamera': 'j_85',
        'mobilebuttonTake': 'j_86',
        'mobilebuttonLibrary': 'j_87',
        'mobilebuttonMiles': 'j_88',
        'mobileCancel': 'j_89',
        'buttonCamera': 'j_90',
        'btnSettings': 'j_91'
    };
    if ("n2id" in window && window.n2id !== undefined) {
        $.extend(n2id, n2id_buf);
    } else {
        window.n2id = n2id_buf;
    }
    Tiggr.CurrentScreen = 'j_69';
    /*************************
     * NONVISUAL COMPONENTS  *
     *************************/
    var datasources = [];
    mobilecameraTakePicture = new Tiggr.DataSource(CameraService, {
        'onComplete': function(jqXHR, textStatus) {
            $t.refreshScreenFormElements("j_69");
        },
        'onSuccess': function(data) {},
        'onError': function(jqXHR, textStatus, errorThrown) {},
        'responseMapping': [{
            'PATH': ['imageURI'],
            'ID': '___local_storage___',
            'ATTR': 'url'
        }],
        'requestMapping': [{
            'PATH': ['quality'],
            'ATTR': '80'
        }, {
            'PATH': ['destinationType'],
            'ATTR': 'Data URL'
        }, {
            'PATH': ['sourcetype'],
            'ATTR': 'Camera'
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
    datasources.push(mobilecameraTakePicture);
    mobilecameraUseLibrary = new Tiggr.DataSource(CameraService, {
        'onComplete': function(jqXHR, textStatus) {
            $t.refreshScreenFormElements("j_69");
        },
        'onSuccess': function(data) {},
        'onError': function(jqXHR, textStatus, errorThrown) {},
        'responseMapping': [],
        'requestMapping': [{
            'PATH': ['quality'],
            'ATTR': '80'
        }, {
            'PATH': ['destinationType'],
            'ATTR': 'Data URL'
        }, {
            'PATH': ['sourcetype'],
            'ATTR': 'Camera',
            'TRANSFORMATION': function(value) {
                return "Photolibrary"
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
    datasources.push(mobilecameraUseLibrary);
    eBISService = new Tiggr.DataSource(ebisService_eBISdata_JSDO, {
        'onComplete': function(jqXHR, textStatus) {
            $t.refreshScreenFormElements("j_69");
        },
        'onSuccess': function(data) {},
        'onError': function(jqXHR, textStatus, errorThrown) {},
        'responseMapping': [],
        'requestMapping': []
    });
    datasources.push(eBISService);
    eBISCapture = new Tiggr.DataSource(ebisService_eBISdata_CaptureExpenses, {
        'onComplete': function(jqXHR, textStatus) {
            $t.refreshScreenFormElements("j_69");
        },
        'onSuccess': function(data) {},
        'onError': function(jqXHR, textStatus, errorThrown) {},
        'responseMapping': [],
        'requestMapping': [{
            'PATH': ['pcMobileDate'],
            'ID': '___local_storage___',
            'ATTR': 'lv_mobileDate'
        }, {
            'PATH': ['pcMobileType'],
            'ID': '___local_storage___',
            'ATTR': 'lv_mobileType'
        }, {
            'PATH': ['pcMobileAmount'],
            'ID': '___local_storage___',
            'ATTR': 'lv_mobileAmount'
        }, {
            'PATH': ['pcMobileReason'],
            'ID': '___local_storage___',
            'ATTR': 'lv_mobileReason'
        }]
    });
    datasources.push(eBISCapture);
    // Tiggzi Push-notification registration service
    /************************
     * EVENTS AND HANDLERS  *
     ************************/
    j_69_beforeshow = function() {
        Tiggzi.CurrentScreen = 'j_69';
        for (var idx = 0; idx < datasources.length; idx++) {
            datasources[idx].__setupDisplay();
        }
    }
    // screen onload
    screen_12CF_onLoad = j_69_onLoad = function() {
        screen_12CF_elementsExtraJS();
        Tiggzi('mobilecontainer1').css('background-image', 'url("' + Tiggzi.getImagePath('bgd_1024x1024.jpg') + '")');
        Tiggzi('buttonAdd').css('background-image', 'url("' + Tiggzi.getImagePath('UIButtonBarAction.jpg') + '")');
        Tiggzi('buttonAdd').css('background-repeat', 'no-repeat');
        Tiggzi('buttonCamera').css('background-image', 'url("' + Tiggzi.getImagePath('camera.png') + '")');
        Tiggzi('buttonCamera').css('background-repeat', 'no-repeat');
        Tiggzi("textAreaNone").attr("disabled", "disabled");
        Tiggzi("textAreaNone").css("height", "10px");
        Tiggzi("textAreaNone").attr("value", "Showing all expenses uploaded.");
        toastDelay = 3000; //message show time
        toast('No Expenses Found');
        toastDelay = 3000; //message show time
        toast('Press the Camera to begin');
        localStorage.setItem('ImageStore', '');
        try {
            eBISService.execute({})
        } catch (ex) {
            console.log(ex.name + '  ' + ex.message);
            hideSpinner();
        };
        var settings;
        var cMsg = "ok";
        try { /* CHANGE THIS TO POINT TO YOUR SETTINGS SERVICE */
            settings = ebisService_eBISdata_Settings;
            pdsession = new progress.data.Session();
            var loginResult = pdsession.login(settings.serviceURI, "", "");
            alert("hello");
            if (loginResult != progress.data.Session.LOGIN_SUCCESS) {
                console.log('ERROR: Login failed with code: ' + loginResult);
                switch (loginResult) {
                case progress.data.Session.LOGIN_AUTHENTICATION_FAILURE:
                    cMsg = 'Invalid user-id or password';
                    break;
                case progress.data.Session.LOGIN_GENERAL_FAILURE:
                default:
                    cMsg = 'Service is unavailable';
                    break;
                }
            }
        } catch (e) {
            cMsg = "Failed to log in";
            console.log(e.stack);
        }
        if (cMsg != "ok") {
            alert(cMsg);
            return;
        }
        pdsession.addCatalog(settings.catalogURl);
        j_69_windowEvents();
        screen_12CF_elementsEvents();
    }
    // screen window events
    screen_12CF_windowEvents = j_69_windowEvents = function() {
        $('#j_69').bind('pageshow orientationchange', function() {
            adjustContentHeightWithPadding();
        });
    }
    // screen elements extra js
    screen_12CF_elementsExtraJS = j_69_elementsExtraJS = function() {
        // screen (screen-12CF) extra code
    }
    // screen elements handler
    screen_12CF_elementsEvents = j_69_elementsEvents = function() {
        $("a :input,a a,a fieldset label").live({
            click: function(event) {
                event.stopPropagation();
            }
        });
        $('#j_2 [name="buttonAdd"]').die().live({
            click: function() {
                if (!$(this).attr('disabled')) {
                    Tiggzi('mobilegroupedbuttons1_38').show();
                }
            },
        });
        $('#j_3 [name="mobileUpload"]').die().live({
            click: function() {
                if (!$(this).attr('disabled')) {
                    alert(localStorage.getItem(lv_receiptAmount));
                    try {
                        eBISCapture.execute({})
                    } catch (ex) {
                        console.log(ex.name + '  ' + ex.message);
                        hideSpinner();
                    };
                }
            },
        });
        $('#j_3 [name="mobileCancel_1"]').die().live({
            click: function() {
                if (!$(this).attr('disabled')) {
                    Tiggzi('mobilegroupedbuttons1_38').hide();
                }
            },
        });
        $('#j_3 [name="mobilebuttonTake"]').die().live({
            click: function() {
                if (!$(this).attr('disabled')) {
                    localStorage.setItem('PhotoType', 'Camera');
                    Tiggzi('mobilebuttonsCamera').hide();
                    if (!$(this).attr('disabled')) {
                        Tiggr.navigateTo('ebisCameraExpense', {
                            transition: 'flip',
                            reverse: false
                        });
                    };
                }
            },
        });
        $('#j_3 [name="mobilebuttonLibrary"]').die().live({
            click: function() {
                if (!$(this).attr('disabled')) {
                    localStorage.setItem('PhotoType', 'Photolibrary');
                    Tiggzi('mobilebuttonsCamera').hide();
                    if (!$(this).attr('disabled')) {
                        Tiggr.navigateTo('ebisCameraExpense', {
                            transition: 'flip',
                            reverse: false
                        });
                    };
                }
            },
        });
        $('#j_3 [name="mobilebuttonMiles"]').die().live({
            click: function() {
                if (!$(this).attr('disabled')) {
                    Tiggzi('mobilebuttonsCamera').hide();
                    if (!$(this).attr('disabled')) {
                        Tiggr.navigateTo('ebisMileageExpense', {
                            transition: 'flip',
                            reverse: false
                        });
                    };
                }
            },
        });
        $('#j_3 [name="mobileCancel"]').die().live({
            click: function() {
                if (!$(this).attr('disabled')) {
                    Tiggzi('mobilebuttonsCamera').hide();
                }
            },
        });
        $('#j_39 [name="buttonCamera"]').die().live({
            click: function() {
                if (!$(this).attr('disabled')) {
                    Tiggzi('mobilebuttonsCamera').show();
                }
            },
        });
        $('#j_39 [name="btnSettings"]').die().live({
            click: function() {
                if (!$(this).attr('disabled')) {
                    Tiggr.navigateTo('grid_test', {
                        transition: 'fade',
                        reverse: false
                    });
                }
            },
        });
    }
    $("#j_69").die("pagebeforeshow").live("pagebeforeshow", function(event, ui) {
        j_69_beforeshow();
    });
    if (runBeforeShow) {
        j_69_beforeshow();
    } else {
        j_69_onLoad();
    }
}
$("#j_69").die("pageinit").live("pageinit", function(event, ui) {
    Tiggzi.processSelectMenu($(this));
    j_69_js();
});
j_0_js = function(runBeforeShow) { /* Object & array with components "name-to-id" mapping */
    var n2id_buf = {
        'mobilegrid_40': 'j_4',
        'mobilegridcell_41': 'j_5',
        'mobilelabel1_61': 'j_6',
        'mobilegridcell_42': 'j_7',
        'mobiledate': 'j_8',
        'mobilegridcell_43': 'j_9',
        'mobilelabel1_63': 'j_10',
        'mobilegridcell_44': 'j_11',
        'mobileReason': 'j_12',
        'mobilegridcell_45': 'j_13',
        'mobilelabel1_64': 'j_14',
        'mobilegridcell_46': 'j_15',
        'mobileMiles': 'j_16',
        'mobilegridcell_47': 'j_17',
        'mobilelabel1_65': 'j_18',
        'mobilegridcell_48': 'j_19',
        'mobileRate': 'j_20',
        'mobilegridcell_49': 'j_21',
        'mobilelabel1_66': 'j_22',
        'mobilegridcell_50': 'j_23',
        'mobileAmount': 'j_24',
        'mobilegridcell_51': 'j_25',
        'mobilelabel1_67': 'j_26',
        'mobilegridcell_52': 'j_27',
        'mobileFrom': 'j_28',
        'mobilegridcell_53': 'j_29',
        'mobilelabel1_68': 'j_30',
        'mobilegridcell_54': 'j_31',
        'mobileTo': 'j_32',
        'mobilegridcell_55': 'j_33',
        'mobilelabel1_69': 'j_34',
        'mobilegridcell_56': 'j_35',
        'mobileNotes': 'j_36',
        'mobileOK': 'j_37',
        'mobilebutton1_60': 'j_38'
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
    restservice1 = new Tiggr.DataSource(GenericService, {
        'onComplete': function(jqXHR, textStatus) {
            $t.refreshScreenFormElements("j_69");
        },
        'onSuccess': function(data) {},
        'onError': function(jqXHR, textStatus, errorThrown) {},
        'responseMapping': [],
        'requestMapping': []
    });
    datasources.push(restservice1);
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
    screen_B0C4_onLoad = j_0_onLoad = function() {
        screen_B0C4_elementsExtraJS();
        Tiggzi('mobilecontainer1').css('background-image', 'url("' + Tiggzi.getImagePath('bgd_1024x1024.jpg') + '")');
        var current_date = new Date();
        var dd = current_date.getDate();
        var mm = current_date.getMonth() + 1; //January is 0! 
        var yyyy = current_date.getFullYear();
        $('[dsid="mobiledate"] input').val(dd + "/" + mm + "/" + yyyy);;
        j_0_windowEvents();
        screen_B0C4_elementsEvents();
    }
    // screen window events
    screen_B0C4_windowEvents = j_0_windowEvents = function() {
        $('#j_0').bind('pageshow orientationchange', function() {
            adjustContentHeightWithPadding();
        });
        $('#j_0').bind({
            pageshow: function() {
                Tiggr("mobileReason").val("");
                Tiggr("mobileMiles").val("");
                Tiggr("mobileFrom").val("");
                Tiggr("mobileTo").val("");
                Tiggr("mobileNotes").val("");
                Tiggr("mobileAmount").val("");
            },
        });
    }
    // screen elements extra js
    screen_B0C4_elementsExtraJS = j_0_elementsExtraJS = function() {
        // screen (screen-B0C4) extra code
        /* mobiledate */
        mobiledatepicker1_selector = "#j_8";
        mobiledatepicker1_dataPickerOptions = {
            dateFormat: "dd/mm/yy",
            firstDay: 0,
            maxDate: new Date(""),
            minDate: new Date(""),
            dayNamesMin: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
            monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
            showOtherMonths: true
        };
        mobiledatepicker1_dataPickerOptions.defaultDate = $.datepicker.formatDate(mobiledatepicker1_dataPickerOptions.dateFormat, new Date("04/08/2013"));
        Tiggzi.__registerComponent('mobiledate', new Tiggzi.TiggziMobileDatePickerComponent("j_8", mobiledatepicker1_dataPickerOptions));
    }
    // screen elements handler
    screen_B0C4_elementsEvents = j_0_elementsEvents = function() {
        $("a :input,a a,a fieldset label").live({
            click: function(event) {
                event.stopPropagation();
            }
        });
        $('#j_3 [name="mobileOK"]').die().live({
            click: function() {
                if (!$(this).attr('disabled')) {
                    setVar_('lv_mobileDate', 'j_8', 'defaultDateValue', '', this);
                    setVar_('lv_mobileReason', 'j_12', 'text', '', this);
                    setVar_('lv_mobileAmount', 'j_24', 'text', '', this);
                    Tiggr.navigateTo('home', {
                        transition: 'flip',
                        reverse: true
                    });
                    // validation goes here ! 
                    var title = "10/4/2013"; // this is from a text input field on your screen 
                    if (title == "") {
                        alert("You must enter a title!");
                        return;
                    }
                    gridInsertRow(localStorage.getItem('lv_mobileDate'), "Mileage", localStorage.getItem('lv_mobileReason'), localStorage.getItem('lv_mobileAmount'));;
                }
            },
        });
        $('#j_3 [name="mobilebutton1_60"]').die().live({
            click: function() {
                if (!$(this).attr('disabled')) {
                    window.location = '#j_69';
                }
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
j_42_js = function(runBeforeShow) { /* Object & array with components "name-to-id" mapping */
    var n2id_buf = {
        'mobilegrid_83': 'j_46',
        'mobilegridcell_84': 'j_47',
        'mobilelabel1_97': 'j_48',
        'mobilegridcell_85': 'j_49',
        'mobiledate': 'j_50',
        'mobilegridcell_86': 'j_51',
        'mobilelabel1_102': 'j_52',
        'mobilegridcell_87': 'j_53',
        'mobileType': 'j_54',
        'mobileselectmenuitem1': 'j_55',
        'mobilegridcell_92': 'j_56',
        'mobilelabel1_90': 'j_57',
        'mobilegridcell_93': 'j_58',
        'mobileReason': 'j_59',
        'mobilegridcell_94': 'j_60',
        'mobilelabel1_91': 'j_61',
        'mobilegridcell_95': 'j_62',
        'mobileAmount': 'j_63',
        'mobilegridcell_98': 'j_64',
        'mobilelabel1_104': 'j_65',
        'mobilegridcell_99': 'j_66',
        'mobileNotes': 'j_67',
        'mobilebutton1_48': 'j_44',
        'mobilebutton1_49': 'j_45',
        'mobileImage': 'j_43'
    };
    if ("n2id" in window && window.n2id !== undefined) {
        $.extend(n2id, n2id_buf);
    } else {
        window.n2id = n2id_buf;
    }
    Tiggr.CurrentScreen = 'j_42';
    /*************************
     * NONVISUAL COMPONENTS  *
     *************************/
    var datasources = [];
    mobilecamera1 = new Tiggr.DataSource(CameraService, {
        'onComplete': function(jqXHR, textStatus) {
            $t.refreshScreenFormElements("j_69");
        },
        'onSuccess': function(data) {},
        'onError': function(jqXHR, textStatus, errorThrown) {},
        'responseMapping': [{
            'PATH': ['imageDataBase64'],
            'ID': 'mobileImage',
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
            'ATTR': 'Camera',
            'TRANSFORMATION': function(value) {
                return localStorage.getItem('PhotoType');
            }
        }, {
            'PATH': ['allowedit'],
            'ATTR': 'true'
        }, {
            'PATH': ['encodingType'],
            'ATTR': 'JPEG'
        }, {
            'PATH': ['targetWidth'],
            'ATTR': '299'
        }, {
            'PATH': ['targetHeight'],
            'ATTR': '299'
        }]
    });
    datasources.push(mobilecamera1);
    // Tiggzi Push-notification registration service
    /************************
     * EVENTS AND HANDLERS  *
     ************************/
    j_42_beforeshow = function() {
        Tiggzi.CurrentScreen = 'j_42';
        for (var idx = 0; idx < datasources.length; idx++) {
            datasources[idx].__setupDisplay();
        }
    }
    // screen onload
    screen_2231_onLoad = j_42_onLoad = function() {
        screen_2231_elementsExtraJS();
        Tiggzi('mobilecontainer1').css('background-image', 'url("' + Tiggzi.getImagePath('bgd_1024x1024.jpg') + '")');
        try {
            mobilecamera1.execute({})
        } catch (ex) {
            console.log(ex.name + '  ' + ex.message);
            hideSpinner();
        };
        setVar_('mobileImage', 'j_43', 'src', '', this);
        var current_date = new Date();
        var dd = current_date.getDate();
        var mm = current_date.getMonth() + 1; //January is 0! 
        var yyyy = current_date.getFullYear();
        $('[dsid="mobiledate"] input').val(dd + "/" + mm + "/" + yyyy);;
        j_42_windowEvents();
        screen_2231_elementsEvents();
    }
    // screen window events
    screen_2231_windowEvents = j_42_windowEvents = function() {
        $('#j_42').bind('pageshow orientationchange', function() {
            adjustContentHeightWithPadding();
        });
        $('#j_42').bind({
            pageshow: function() {
                try {
                    mobilecamera1.execute({})
                } catch (ex) {
                    console.log(ex.name + '  ' + ex.message);
                    hideSpinner();
                };
                Tiggr("mobileReason").val("");
                Tiggr("mobileType").val("");
                Tiggr("mobileNotes").val("");
                Tiggr("mobileAmount").val("");
            },
        });
    }
    // screen elements extra js
    screen_2231_elementsExtraJS = j_42_elementsExtraJS = function() {
        // screen (screen-2231) extra code
        /* mobiledate */
        mobiledatepicker2_selector = "#j_50";
        mobiledatepicker2_dataPickerOptions = {
            dateFormat: "dd/mm/yy",
            firstDay: 0,
            maxDate: new Date(""),
            minDate: new Date(""),
            dayNamesMin: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
            monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
            showOtherMonths: true
        };
        mobiledatepicker2_dataPickerOptions.defaultDate = $.datepicker.formatDate(mobiledatepicker2_dataPickerOptions.dateFormat, new Date("04/08/2013"));
        Tiggzi.__registerComponent('mobiledate', new Tiggzi.TiggziMobileDatePickerComponent("j_50", mobiledatepicker2_dataPickerOptions)); /* mobileType */
        $("#j_54").parent().find("a.ui-btn").attr("tabindex", "4");
    }
    // screen elements handler
    screen_2231_elementsEvents = j_42_elementsEvents = function() {
        $("a :input,a a,a fieldset label").live({
            click: function(event) {
                event.stopPropagation();
            }
        });
        $('#j_3 [name="mobilebutton1_48"]').die().live({
            click: function() {
                if (!$(this).attr('disabled')) {
                    setVar_('lv_mobileDate', 'j_50', 'defaultDateValue', '', this);
                    setVar_('lv_mobileType', 'j_54', 'value', '', this);
                    setVar_('lv_mobileReason', 'j_59', 'text', '', this);
                    setVar_('lv_mobileAmount', 'j_63', 'text', '', this);
                    Tiggr.navigateTo('home', {
                        transition: 'fade',
                        reverse: false
                    });
                    // validation would go in here 
                    var title = "10/4/2013"; // this is from a text input field on your screen 
                    if (title == "") {
                        alert("You must enter a title!");
                        return;
                    }
                    gridInsertRow(localStorage.getItem('lv_mobileDate'), localStorage.getItem('lv_mobileType'), localStorage.getItem('lv_mobileReason'), localStorage.getItem('lv_mobileAmount'));
                    Tiggr("txtTitle").val("");;
                }
            },
        });
        $('#j_3 [name="mobilebutton1_49"]').die().live({
            click: function() {
                if (!$(this).attr('disabled')) {
                    window.location = '#j_69';
                }
            },
        });
        $('#j_3 [name="mobileImage"]').die().live({
            swipeleft: function() {
                try {
                    mobilecamera1.execute({})
                } catch (ex) {
                    console.log(ex.name + '  ' + ex.message);
                    hideSpinner();
                };
            },
            swiperight: function() {
                try {
                    mobilecamera1.execute({})
                } catch (ex) {
                    console.log(ex.name + '  ' + ex.message);
                    hideSpinner();
                };
            },
        });
    }
    $("#j_42").die("pagebeforeshow").live("pagebeforeshow", function(event, ui) {
        j_42_beforeshow();
    });
    if (runBeforeShow) {
        j_42_beforeshow();
    } else {
        j_42_onLoad();
    }
}
$("#j_42").die("pageinit").live("pageinit", function(event, ui) {
    Tiggzi.processSelectMenu($(this));
    j_42_js();
});
j_96_js = function(runBeforeShow) { /* Object & array with components "name-to-id" mapping */
    var n2id_buf = {
        'mobilenavbar2_40': 'j_97',
        'mobilenavbaritem4_42': 'j_98',
        'mobilenavbaritem4_43': 'j_99',
        'myGrid_1': 'j_100',
        'mobilegridcell_45': 'j_101',
        'mobilelabel1_52': 'j_102',
        'mobilegridcell_53': 'j_103',
        'mobilelabel1_55': 'j_104',
        'mobilegridcell_54': 'j_105',
        'mobilelabel1_56': 'j_106',
        'mobilegridcell_57': 'j_107',
        'mobilelabel1_59': 'j_108',
        'mobilegridcell_58': 'j_109',
        'mobilegridcell_61': 'j_110',
        'myList': 'j_111',
        'mobilelistitem1_64': 'j_112',
        'mobilelistitembtn1_65': 'j_113',
        'mobilelabel1_71': 'j_114',
        'list': 'j_115',
        'mobilegridcell_74': 'j_116',
        'mobilegridcell_84': 'j_117',
        'mobilegridcell_86': 'j_118'
    };
    if ("n2id" in window && window.n2id !== undefined) {
        $.extend(n2id, n2id_buf);
    } else {
        window.n2id = n2id_buf;
    }
    Tiggr.CurrentScreen = 'j_96';
    /*************************
     * NONVISUAL COMPONENTS  *
     *************************/
    var datasources = [];
    // Tiggzi Push-notification registration service
    /************************
     * EVENTS AND HANDLERS  *
     ************************/
    j_96_beforeshow = function() {
        Tiggzi.CurrentScreen = 'j_96';
        for (var idx = 0; idx < datasources.length; idx++) {
            datasources[idx].__setupDisplay();
        }
    }
    // screen onload
    screen_33EC_onLoad = j_96_onLoad = function() {
        screen_33EC_elementsExtraJS();
        Tiggzi('grid_test').css('background-image', 'url("' + Tiggzi.getImagePath('bgd_1024x1024.jpg') + '")');
        j_96_windowEvents();
        screen_33EC_elementsEvents();
    }
    // screen window events
    screen_33EC_windowEvents = j_96_windowEvents = function() {
        $('#j_96').bind('pageshow orientationchange', function() {
            adjustContentHeightWithPadding();
        });
    }
    // screen elements extra js
    screen_33EC_elementsExtraJS = j_96_elementsExtraJS = function() {
        // screen (screen-33EC) extra code
        /* mobilelist1 */
        listView = $("#j_111");
        theme = listView.attr("data-theme");
        if (typeof theme !== 'undefined') {
            var themeClass = "ui-btn-up-" + theme;
            listItem = $("#j_111 .ui-li-static");
            $.each(listItem, function(index, value) {
                $(this).addClass(themeClass);
            });
        } /* mobilelistitem1_64 */
    }
    // screen elements handler
    screen_33EC_elementsEvents = j_96_elementsEvents = function() {
        $("a :input,a a,a fieldset label").live({
            click: function(event) {
                event.stopPropagation();
            }
        });
        $('#j_2 [name="mobilenavbaritem4_42"]').die().live({
            click: function() {
                if (!$(this).attr('disabled')) {
                    window.location = '#j_69';
                }
            },
        });
        $('#j_2 [name="mobilenavbaritem4_43"]').die().live({
            click: function() {
                if (!$(this).attr('disabled')) {
                    var title = "10/4/2013"; // this is from a text input field on your screen 
                    if (title == "") {
                        alert("You must enter a title!");
                        return;
                    }
                    gridInsertRow(title);
                    Tiggr("txtTitle").val("");;
                    Tiggr('myList').append('<li><a>Air Fare</a></li>');
                    Tiggr('myList').listview('refresh');
                }
            },
        });
    }
    $("#j_96").die("pagebeforeshow").live("pagebeforeshow", function(event, ui) {
        j_96_beforeshow();
    });
    if (runBeforeShow) {
        j_96_beforeshow();
    } else {
        j_96_onLoad();
    }
}
$("#j_96").die("pageinit").live("pageinit", function(event, ui) {
    Tiggzi.processSelectMenu($(this));
    j_96_js();
});