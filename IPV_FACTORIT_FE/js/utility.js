$(function () {
    initApp();
});
function initApp() {
    //checkSession();
    //initClient();
    //initLang();
    //initCustomCtl();
}
function checkSession() {
    //var dfd = new $.Deferred();
    //$.when( this.callApiRestFermata() )
    //    .done( function () {
    //        that.finishLoading();
    //        return dfd.resolve();
    //    })
    //    .fail(function () {
    //        dfd.reject()
    //    });
    //return dfd.promise()

    try {
        //alert(window.location.host);
        if (window.location.href.indexOf("index") == -1) {
            userStorage = JSON.parse(localStorage.getItem("session"));
            if (userStorage != null) {
                try {
                    $.ajax({
                        url: appConfig.apiPrefix + 'session',
                        contentType: 'application/json',
                        dataType: 'json',
                        data: null,
                        type: 'get',
                        headers: {
                            lang: userStorage.lang.substring(0, 2),
                            matricola: userStorage.matricola,
                            token: userStorage.token,
                            module: userStorage.module,
                            licenseKey: userStorage.licenseKey,
                        },
                        success: function (data, response, options) {
                            //alert("ok");
                            // saving <idetur> in session
                            userStorage.idetur = data.idetur;
                            userStorage.name = data.name;
                            userStorage.lastname = data.lastname;
                            userStorage.profilo = data.profilo;
                            $(".name").html(data.name + " " + data.lastname);
                            $(".profilo").html(" [" + userStorage.profilo + "]");
                            if (userStorage.idetur == undefined || userStorage.idetur == "") {
                                // Aggiorno l'etichetta in <Apri turno>.
                                $("#b4cb0878e529245a6795a1afde1aae72").attr("for", "b056a8b9f36bdaef53ed90db6e751f83");
                                // Aggiorno su <OFF> lo stato del turno.
                                $(".operatore").children("i").removeClass().addClass("fa fa-circle cLightGray");
                            }
                            else {
                                // Aggiorno l'etichetta in <Chiudi turno>.
                                $("#b4cb0878e529245a6795a1afde1aae72").attr("for", "ffa6a3b21f0a73bc284c045cf427337f");
                                // Aggiorno su <ON> lo stato del turno.
                                $(".operatore").children("i").removeClass().addClass("fa fa-circle cVerde");
                            }
                            localStorage.setItem("session", JSON.stringify(userStorage));
                            initLang();
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            //alert("err");
                            if (jqXHR.status != 200) {
                                clearSession();
                            }
                        }
                    });
                }
                catch (err) {
                    displayAppError();
                    return false;
                }
            }
            else {
                clearSession();
            }
        }
    }
    catch (err) {
        displayAppError();
        return false;
    }
    return true;
}
function injectPrivateHeader() {
    return {
        lang: userStorage.lang.substring(0, 2),
        licenseKey: userStorage.licenseKey,
        module: userStorage.module,
    }
}
function injectHeader() {
    return {
        lang: userStorage.lang.substring(0, 2),
        licenseKey: userStorage.licenseKey,
        matricola: userStorage.matricola,
        token: userStorage.token,
        module: userStorage.module
    }
}
function initClient() {
    $("#appDate").html(getCurrDate);
    var current_languages;
    if (!window.localStorage && !window.sessionStorage) {
        //alert("I'm sorry, Local Storage and Session Storage are not supported in your browser. Upgrade it or use another browser like Firefox, Chrome or Safari.");
    }
    if (window.File && window.FileReader && window.FileList && window.Blob) {
        // All the File APIs are supported.
    } else {
        // alert('The File APIs are not fully supported in this browser.');
    }
    console.log("initClient");
}
function initCustomCtl() {
    $("#go2Top").click(function () {
        $("html, body").animate({ scrollTop: 0 }, "slow");
    });
    $("input[type=radio].custom").each(function (index, ctl) {
        //console.log(ctl.id);
        $("#" + ctl.id).change(function () {
            //console.log(ctl.id);
            $(ctl).parent().children(".req").val($(ctl).val());
        });
    });
    $("input[type=file].custom").each(function (index, ctl) {
        $("#" + ctl.id).change(function () {
            if (readFile(ctl)) {
                $(ctl).parent().parent().children("div").children(".req").val("true");
                if ($(ctl).attr("preview")) {
                    previewFile(ctl);
                }
            }
        });
    });
    $.datepicker.setDefaults($.datepicker.regional[userStorage.lang]);
    $(".data:input").datepicker();
    $("#txt_Residenza_cav,#txt_Domicilio_cav").keydown(function (e) {
        if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 110, 190]) !== -1 ||
            (e.keyCode == 65 && (e.ctrlKey === true || e.metaKey === true)) ||
            (e.keyCode >= 35 && e.keyCode <= 40)) {
            return;
        }
        if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
            e.preventDefault();
        }
    });
}
function getCurrDate() {
    var weekdays = ["<span class='control-label' ita='Domenica' eng='Sunday'></span>",
                    "<span class='control-label' ita='Lunedi' eng='Monday'></span>",
                    "<span class='control-label' ita='Martedi' eng='Tuesday'></span>",
                    "<span class='control-label' ita='Mercoledi' eng='Wednesday'></span>",
                    "<span class='control-label' ita='Giovedi' eng='Thursday'></span>",
                    "<span class='control-label' ita='Venerdi' eng='Friday'></span>",
                    "<span class='control-label' ita='Sabato' eng='Saturday'></span>"];
    var currdate = new Date();
    return "<span class='control-label cMagenta' ita='Oggi è&nbsp;' eng='Today is&nbsp;'></span>" + weekdays[currdate.getDay()] + "<span class='control-label'>, " + currdate.getDate() + "/" + (currdate.getMonth()+1) + "/" + currdate.getFullYear() + "</span>";
}
function initLang(container, language_model) {
    try {
        var lang;
        if (container != undefined) {
            elements = document.getElementById(container).getElementsByClassName("control-label");
        }
        else {
            elements = document.getElementsByClassName("control-label");
        }
        if (language_model != undefined) {
            lang = language_model;
        } else {
            lang = current_languages;
        }
        for (i = 0; i <= elements.length; i++) {
            if (elements[i] != undefined) {
                el = elements[i];
                if ($(el).attr(userStorage.lang) != undefined) {
                    $(el).html($(el).attr(userStorage.lang));
                }
                else {
                    if (lang.get($(el).attr("for")) != undefined) {
                        $(el).html(lang.get($(el).attr("for"))[userStorage.lang.toLowerCase()]);
                    }
                }
            }
        }
        if (container != undefined) {
            elements = document.getElementById(container).getElementsByClassName("btn");
        }
        else {
            elements = document.getElementsByClassName("btn");
        }
        for (i = 0; i <= elements.length; i++) {
            if (elements[i] != undefined) {
                el = elements[i];
                $(el).attr("value", $(el).attr(userStorage.lang));
            }
        }
    } catch (err) {
        console.log(err.message);
    }
}
function initLabel() {
    $('.labelReq').each(function (index, element) {
        $(this).attr("class", "control-label");
    });
}
function hasStorage() {
    try {
        return 'localStorage' in window && window['localStorage'] !== null;
    } catch (e) {
        return false;
    }
}
function displayAccountAlreadyExist() {
    displayError('<p class="control-label" ita="' + appMessage.accountAlreadyExist + '" eng="' + appMessage.accountAlreadyExist + '"></p>');
}
function displayAccountError() {
    displayError('<p class="control-label" ita="' + appMessage.accountError + '" eng="' + appMessage.accountError + '"></p>');
}
function displayAccountNotFound() {
    displayError('<p class="control-label" ita="' + appMessage.accountNotFound + '" eng="' + appMessage.accountNotFound + '"></p>');
}
function displayMailError() {
    displayError('<p class="control-label" ita="' + appMessage.mailError + '" eng="' + appMessage.mailError + '"></p>');
}
function displayAppError() {
    displayError("<p class='control-label' ita='" + appMessage.defaultError + "' eng='" + appMessage.defaultError + "'></p>");
}
function displayDefaultError() {
    displayError(null);
}
function setFocusToEl(el) {
    $(el).parent().find(".control-label").attr("class", "labelReq");
    el.focus(); $("html, body").animate({ scrollTop: eval(el.offset().top) + eval(-100) }, "slow");
}
function setModelValue(ctl) {
    if ($(ctl).prop("tagName").toLowerCase() == "select") {
        switch ($(ctl).prop("tagName").toLowerCase()) {
            case "select":      return $(ctl).val(); break;
        }
    }
    else {
        switch ($(ctl).attr("type")) {
            case "text":        return $(ctl).val(); break;
            case "hidden":      return $(ctl).val(); break;
            case "password":    return $(ctl).val(); break;
            case "checkbox":    return getCheckValue($("#" + ctl.id)); break;
        }
    }
}
function checkControlValue(ctl) {
    if ($(ctl).prop("tagName").toLowerCase() == "select") {
        switch ($(ctl).prop("tagName").toLowerCase()) {
            case "select":      return !$(ctl).val(); break;
        }
    }
    else {
        switch ($(ctl).attr("type")) {
            case "text":        return !$(ctl).val(); break;
            case "hidden":      return !$(ctl).val(); break;
            case "password":    return !$(ctl).val(); break;
            case "checkbox":    return !$(ctl).is(':checked'); break;
        }
    }

}
function getCheckValue(check) {
    var checkVal = "false";
    if (check.is(':checked')) {
        checkVal = "true";
    }
    return checkVal;
}
function checkFileType(exts, type) {
    var res = false;
    $.each(exts.split(","), function (index, ext) {
        //  "type: " + type + ", ext: " + ext);
        if (type.indexOf(ext) > -1) {
            res = true;
            return false;
        }
    })
    return res;
}
function readFile(input) {
    var __ = $("#txt" + input.id.substring(input.id.indexOf("_")));
    var size = __.attr("size");
    var ext = __.attr("ext");
    var _ = input.files[0];
    if ((eval(_.size / 1024)) > (eval(size)*1024)) {
        return displayError('<label class="control-label" ' +
                        'ita="Dimensione massima consentita: 1MB." ' +
                        'eng="Max file allowed: 1MB."' +
                     '></label>');
    }
    if (!checkFileType(ext, _.type)) {
        return displayError('<label class="control-label" ' +
                'ita="Puoi inserire solo file nel formato (' + ext + ')." ' +
                'eng="You can only include files in (' + ext + ') format. "' +
             '></label>');
    }
    return true;
}
function previewFile(input) {
    if (input.files && input.files[0]) {
        var image = new Image();
        var reader = new FileReader();
        reader.onload = function (e) {
            $("#img_" + input.id.split("_")[input.id.split("_").length - 1]).attr('src', e.target.result);
        };
        reader.readAsDataURL(input.files[0]);
    }
}
function validateEmail(sEmail) {
    var filter = /^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    if (filter.test(sEmail)) {
        return true;
    }
    else {
        return false;
    }
}
function getNazioni(container)
{
    $.ajax({
        //url: 'api/countries',
        url: appConfig.apiPrefix + 'nazioni',
        dataType: 'json',
        type: 'GET', 
        headers: {
            lang: userStorage.lang.substring(0, 2),
            licenseKey: userStorage.licenseKey,
            module: userStorage.module,
        },
        success: function (data) {
            container.html('');
            container.append("<option value=''>...</option>");
            $.each(data, function(key, val){
                container.append('<option value="' + val.idenaz + '">' + val.des.toUpperCase() + '</option>');
            })
        },
        error: function (request, error) {
            container.html('<option value="">...</option>');
        }
    });
}
function getRegioni(container) {
    $.ajax({
        url: appConfig.apiPrefix + 'regioni',
        dataType: 'json',
        type: 'GET',
        headers: {
            lang: userStorage.lang.substring(0, 2),
            licenseKey: userStorage.licenseKey,
            module: userStorage.module,
        },
        success: function (data) {
            container.html('');
            container.append("<option value=''>...</option>");
            $.each(data, function (key, val) {
                container.append('<option value="' + val.codrgn + '">' + val.den + '</option>');
            })
        },
        error: function (request, error) {
            container.html('<option value="">...</option>');
        }
    });
}
function getProvince(container, codrgn) {
    try
    {
        $("#loader").show();
        $.ajax({
            url: appConfig.apiPrefix + 'province;regione=' + codrgn,
            dataType: 'json',
            type: 'GET',
            headers: {
                lang: userStorage.lang.substring(0, 2),
                licenseKey: userStorage.licenseKey,
                module: userStorage.module,
            },
            success: function (data) {
                container.html('');
                container.append("<option value=''>...</option>");
                $.each(data, function (key, val) {
                    container.append('<option value="' + val.codpnc + '">' + val.den + '</option>');
                })
                $('#loader').hide();
            },
            error: function (request, error) {
                container.html('<option value="">...</option>');
                $('#loader').hide();
            }
        });
    }
    catch (err) {
        $('#loader').hide();
    }
}
function getComune(container, codpnc) {
    try
    {
        $("#loader").show();
        $.ajax({
            url: appConfig.apiPrefix + 'comune;provincia=' + codpnc,
            dataType: 'json',
            type: 'GET',
            headers: {
                lang: userStorage.lang.substring(0, 2),
                licenseKey: userStorage.licenseKey,
                module: userStorage.module,
            },
            success: function (data) {
                container.html('');
                container.append("<option value=''>...</option>");
                $.each(data, function (key, val) {
                    container.append('<option value="' + val.codcmn + '">' + val.den + '</option>');
                })
                $('#loader').hide();
            },
            error: function (request, error) {
                container.html('<option value="">...</option>');
                $('#loader').hide();
            }
        });
    }
    catch (err) {
        $('#loader').hide();
    }
}
function getServicePoints(container) {
    $.ajax({
        url: appConfig.apiPrefix + 'rivendite',
        dataType: 'json',
        type: 'GET',
        headers: {
            lang: userStorage.lang.substring(0, 2),
            licenseKey: userStorage.licenseKey,
            module: userStorage.module,
        },
        success: function (data) {
            container.html('');
            container.append("<option value=''>...</option>");
            $.each(data, function (key, val) {
                container.append('<option value="' + val.codrve + '">' + val.den + '</option>');
            })
        },
        error: function (request, error) {
            container.html('<option value="">...</option>');
        }
    });
}
function getIstituti(container) {
    $.ajax({
        url: appConfig.apiPrefix + 'istituti',
        dataType: 'json',
        type: 'GET',
        headers: {
            lang: userStorage.lang.substring(0, 2),
            licenseKey: userStorage.licenseKey,
            module: userStorage.module,
        },
        success: function (data) {
            container.html('');
            container.append("<option value=''>...</option>");
            $.each(data, function (key, val) {
                container.append('<option value="' + val.idesuo + '">' + val.densuoditete.toUpperCase() + '</option>');
            })
        },
        error: function (request, error) {
            container.html('<option value="">...</option>');
        }
    });
}
function getProfessioni(container) {
    $.ajax({
        //url: 'api/professioni',
        url: appConfig.apiPrefix + 'professioni',
        dataType: 'json',
        type: 'GET',
        headers: {
            lang: userStorage.lang.substring(0, 2),
            licenseKey: userStorage.licenseKey,
            module: userStorage.module,
        },
        success: function (data) {
            container.html('');
            container.append("<option value=''>...</option>");
            $.each(data, function (key, val) {
                container.append('<option value="' + val.idetippfe + '">' + val.destippfe + '</option>');
            })
        },
        error: function (request, error) {
            container.html('<option value="">...</option>');
        }
    });
}
function getSingleQueryString(search_for) {
    var query = window.location.search.substring(1);
    var parms = query.split('&');
    for (var i = 0; i < parms.length; i++) {
        var pos = parms[i].indexOf('=');
        if (pos > 0 && search_for == parms[i].substring(0, pos)) {
            return parms[i].substring(pos + 1);
        }
    }
    return "";
}
function parseDate(date) {
    try {
        var objDate = date.split("-");
        return objDate[2] + "/" +
                objDate[1] + "/" +
                objDate[0];
    } catch (err) {
        displayError("clearDate: " + err.message);
    }
}
function clearDate(date) {
    try {
        var objDate = date.split("/");
        return objDate[2] + "-" +
                objDate[1] + "-" +
                objDate[0];
    } catch (err) {
        displayError("clearDate: " + err.message);
    }
}
$(function () {
    appAlert = new confirm({ collection: { id: "myModal-1", defaultConfirm: null, doubleConfirm: null, onConfirm: null, title: null } });
    appNotify = new notify({ collection: { title: null, text: null, type: null } });
});
