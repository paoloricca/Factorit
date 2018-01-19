var userStorage;
var storage = window["localStorage"];
if (!storage.getItem("session")) {
    userStorage = new model_session();
    storage.setItem("session", JSON.stringify(userStorage));
}
userStorage = JSON.parse(storage.getItem("session"));
$(function () {
    //if (userStorage.lang == "ITA") {
    //    $("#aLang").find("i").html("ENG");
    //}
    //else {
    //    $("#aLang").find("i").html("ITA");
    //}
    //$("#aLang").click(function () {
    //    userStorage.lang = $("#aLang").find("i").html();
    //    storage.setItem("session", JSON.stringify(userStorage));
    //    $(window.location).attr('href', 'index.html');
    //});
    //console.log("userStorage.lang: " + userStorage.lang);
});
function clearSession() {
    localStorage.clear();
    document.location.href = 'index.html';
}

