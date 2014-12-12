/*
 * Service settings
 */
var ebisService_eBISdata_Settings = {
    "catalogURL": "/ebisService/static/mobile/ebisService.json",
    "serviceURL": "/ebisService",
    "resourceName": "eBISdata"
}
var ebisTypes_getTypes_Settings = {
    "catalogURL": "/ebisTypes/static/mobile/ebisTypes.json",
    "serviceURL": "/ebisTypes",
    "resourceName": "getTypes"
}
var ebisGroups_getGroups_Settings = {
    "catalogURL": "/ebisGroups/static/mobile/ebisGroups.json",
    "serviceURL": "/ebisGroups",
    "resourceName": "getGroups"
}
var ebisFields_getFields_Settings = {
    "catalogURL": "/ebisFields/static/mobile/ebisFields.json",
    "serviceURL": "/ebisFields",
    "resourceName": "getFields"
}
/*
 * Services
 */
ebisService_eBISdata_JSDO = new Appery.JSDO({

    'serviceSettings': ebisService_eBISdata_Settings
});

ebisTypes_getTypes_JSDO = new Appery.JSDO({

    'serviceSettings': ebisTypes_getTypes_Settings
});

ebisGroups_getGroups_JSDO = new Appery.JSDO({

    'serviceSettings': ebisGroups_getGroups_Settings
});

ebisFields_getFields_JSDO = new Appery.JSDO({

    'serviceSettings': ebisFields_getFields_Settings
});

ebisService_eBISdata_eeBis_Row = new Appery.JSDORow({

    'service': ebisService_eBISdata_JSDO,
    'tableName': 'eeBis'
});

ebisService_eBISdata_CaptureExpense = new Appery.JSDOInvoke({

    'service': ebisService_eBISdata_JSDO,
    'methodName': 'CaptureExpense'
});

ebisService_eBISdata_eeBis_Create = new Appery.JSDOCreate({

    'service': ebisService_eBISdata_JSDO,
    'tableName': 'eeBis'
});

ebisService_eBISdata_eeBis_Delete = new Appery.JSDODelete({

    'service': ebisService_eBISdata_JSDO,
    'tableName': 'eeBis'
});

ebisService_eBISdata_eeBis_Update = new Appery.JSDOUpdate({

    'service': ebisService_eBISdata_JSDO,
    'tableName': 'eeBis'
});

ebisService_eBISdata_Read = new Appery.JSDORead({

    'service': ebisService_eBISdata_JSDO,
    'tableName': 'eeBis'
});

ebisGroups_getGroups_Read = new Appery.JSDORead({

    'service': ebisGroups_getGroups_JSDO,
    'tableName': 'eGroup'
});

ebisGroups_getGroups_eGroup_Row = new Appery.JSDORow({

    'service': ebisGroups_getGroups_JSDO,
    'tableName': 'eGroup'
});

ebisTypes_getTypes_Read = new Appery.JSDORead({

    'service': ebisTypes_getTypes_JSDO,
    'tableName': 'eTypes'
});

ebisTypes_getTypes_eTypes_Row = new Appery.JSDORow({

    'service': ebisTypes_getTypes_JSDO,
    'tableName': 'eTypes'
});

ebisFields_getFields_eFields_Row = new Appery.JSDORow({

    'service': ebisFields_getFields_JSDO,
    'tableName': 'eFields'
});

ebisFields_getFields_Read = new Appery.JSDORead({

    'service': ebisFields_getFields_JSDO,
    'tableName': 'eFields'
});

FavJSON_Read = new Appery.FavJSONRead({});
var CameraService = new Appery.CameraService({});
ExpenseJSON_Read = new Appery.ExpenseJSONRead({});
ExpenseJSON_Write = new Appery.ExpenseJSONWrite({});
Groups_Read_LocalStorage = new Appery.GroupsReadLocalStorage({});
SettingsJSON_Read = new Appery.SettingsJSONRead({});
FavJSON_Row = new Appery.FavJSONRow({});
FavJSON_Write = new Appery.FavJSONWrite({});
ExpenseJSONRow = new Appery.ExpenseJSONRow({});