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