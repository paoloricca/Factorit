function initCustomCtl() {
    $(".dropdown-menu.combo li a").click(function () {
        $(this).parent().parent().parent().parent().children("input").val($(this).children("span").attr("value"));
        $(this).parent().parent().parent().children("button").children(".pull-left").html($(this).html());
        $(".popover").hide();
        //alert($(this).parent().parent().parent().parent().children("input").val());
        //if (window["classType_Change"]) {
        //    window["classType_Change"]($(this).children("span").attr("value"));
        //}
    });
}

$(function () {
    //$(".input-group-addon.culture").parent("div").children("input").change(function () {
    //    $(this).attr("ita", $(this).val());
    //});
    //$(".input-group-addon.culture").click(function () {
    //    culturize.elementId = $(this).parent("div").children("input").attr("id");
    //    culturize.title = $(this).parent("div").parent("div").children("div").children("label").attr(userStorage.lang.toLowerCase());
    //    culturize.current = $(this).parent("div").children("input").attr(userStorage.lang.toLowerCase());
    //    culturize.ita = $(this).parent("div").children("input").attr("ita");
    //    culturize.eng = $(this).parent("div").children("input").attr("eng");
    //    culturize.show();
    //});
    //$("#go2Top").click(function () {
    //    $("html, body").animate({ scrollTop: 0 }, "slow");
    //});
    //$("input[type=radio].custom").each(function (index, ctl) {
    //    $("#" + ctl.id).change(function () {
    //        $(ctl).parent().children(".req").val($(ctl).val());
    //    });
    //});
    //$("input[type=file].custom").each(function (index, ctl) {
    //    $("#" + ctl.id).change(function () {
    //        if (readFile(ctl)) {
    //            $(ctl).parent().parent().children(".req").val("true");
    //            if ($(ctl).attr("preview")) {
    //                previewFile(ctl);
    //            }
    //        }
    //    });
    //});
    //$.datepicker.setDefaults($.datepicker.regional[userStorage.lang]);
    //$(".data:input").datepicker();
    //$('.dropdown-toggle').dropdown();
    //$('[data-toggle="popover"]').popover({
    //    html: true,
    //    container: 'body',
    //});
    //$(document).ready(function () {
    //    $('[data-toggle="tooltip"]').tooltip({});
    //});
});