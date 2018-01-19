var userStorage;
if (!localStorage.getItem("session")) {
    userStorage = new model_session();
    localStorage.setItem("session", JSON.stringify(userStorage));
}
userStorage = JSON.parse(localStorage.getItem("session"));
$(function () {
    if (userStorage.lang == "ITA") {
        $("#aLang").find("i").html("ENG");
    }
    else {
        $("#aLang").find("i").html("ITA");
    }
    $("#aLang").click(function () {
        userStorage.lang = $("#aLang").find("i").html();
        localStorage.setItem("session", JSON.stringify(userStorage));
        $(window.location).attr('href', 'index.html');
    });
    console.log("userStorage.lang: " + userStorage.lang);
});

