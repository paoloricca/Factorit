function initLabel() {
    $('.labelReq').each(function (index, element) {
        $(this).attr("class", "control-label");
    });
}
function validateControl(ctl, model) {
    if ($(ctl).attr("class").indexOf("custom") < 0) {
        var jsonsrc = ctl.id.split("_")[ctl.id.split("_").length - 1].toLowerCase();
        if ($(ctl).attr("parent")) {
            if ($(ctl).attr("parent").indexOf(",") != -1) {
                var _ = $(ctl).attr("parent").split(",");
                var el; switch (_.length) {
                    case 2: el = model.get(_[0])[_[1]]; break;
                    case 3: el = model.get(_[0])[_[1]][_[2]]; break;
                    case 4: el = model.get(_[0])[_[1]][_[2]][_[3]]; break;
                    case 5: el = model.get(_[0])[_[1]][_[2]][_[3]][_[4]]; break;
                }
                el[jsonsrc] = setModelValue(ctl);
            }
            else {
                //console.log("jsonsrc = " + jsonsrc + ", ctl.id = " + ctl.id + ", step: " + 1);
                model.get($(ctl).attr("parent"))[jsonsrc] = setModelValue(ctl);
            }
        }
        else {
            //console.log("ctl.id = " + ctl.id + ", step: " + 2);
            model.set(jsonsrc, setModelValue(ctl));
        }
    }
}
function validates(models) {
    initLabel();
    var warnings = new errors();
    $('.req').each(function (index, ctl) {
        if ($(ctl).attr("model") != undefined) {
            if (models[$(ctl).attr("model")] != undefined) {
                if ($(ctl).is(':visible') && checkControlValue(ctl)) {
                    warnings.add({ descE: $(ctl).parent().children(".control-label").html(), targetID: ctl.id })
                    $(ctl).parent().find(".control-label").attr("class", "labelReq");
                }
                validateControl(ctl, models[$(ctl).attr("model")]);
            }
        }
    });
    $('.optional').each(function (index, ctl) {
        if ($(ctl).attr("model") != undefined) {
            if (models[$(ctl).attr("model")] != undefined) {
                validateControl(ctl, models[$(ctl).attr("model")]);
            }
        }
    });
    if (warnings.length) {
        displayErrors(warnings);
        return false;
    }
    else {
        return true;
    }
}
function checkControlValue(ctl) {
    if ($(ctl).prop("tagName").toLowerCase() == "select") {
        switch ($(ctl).prop("tagName").toLowerCase()) {
            case "select": return !$(ctl).val(); break;
        }
    }
    else {
        switch ($(ctl).attr("type")) {
            case "text": return !$(ctl).val(); break;
            case "hidden": return !$(ctl).val(); break;
            case "password": return !$(ctl).val(); break;
            case "checkbox": return !$(ctl).is(':checked'); break;
        }
    }

}
function validator(container) {
    initLabel();
    var warnings = new errors();
    if (container != undefined && container != null) {
        ctl = document.getElementById(container).getElementsByClassName("req");
    }
    else {
        ctl = document.getElementsByClassName("req");
    }
    for (i = 0; i <= ctl.length; i++) {
        if ($(ctl[i]).is(':visible') && checkControlValue(ctl[i])) {
            warnings.add(
                {
                    descE: $(ctl[i]).parent().children(".control-label").html(),
                    targetID: $(ctl[i]).attr("id"),
                })
            $(ctl[i]).parent().find(".control-label").attr("class", "labelReq");
        }
    }
    if (warnings.length) {
        displayErrors(warnings);
        return false;
    }
    else {
        return true;
    }
}