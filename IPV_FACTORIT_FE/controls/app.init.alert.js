var confirm = Backbone.View.extend({
    hideTitle: false,
    terms: "",
    title: "",
    message: "",
    type: "",
    initialize: function () {
        this.render();
        this.draw()
    },
    render: function () {
        var self = this;
        $("#" + self.collection.id).html(
            '<div id="confirm-' + self.collection.id + '" class="modal fade" terms="">' +
                '<div class="modal-dialog">' +
                    '<div class="modal-content">' +
                        '<div id="header-' + self.collection.id + '" class="modal-header">' +
                            '<p><i class="fa fa-times pull-right" data-dismiss="modal"></i></p>' +
                            '<h4 class="modal-title"><span class="control-label" id="headerTitle-' + self.collection.id + '">' + self.collection.title + '</span></h4>' +
                        '</div>' +
                        '<div class="modal-body">' +
                            '<div class="row">' +
                                '<div class="col-sm-1 pull-left"><i id="modalIcon-' + self.collection.id + '"></i></div>' +
                                '<div class="col-sm-11">' +
                                    '<h4 id="messageHeader"><span class="control-label" ita="Attenzione" eng="Warning"></span></h4>' +
                                    '<h5><span id="messageTitle-' + self.collection.id + '">' + self.collection.defaultConfirm + '</span></h5>' +
                                '</div>' +
                            '</div>' +
                        '</div>' +
                        '<div class="modal-footer">' +
                            '<button type="button" class="btn btn-default" data-dismiss="modal"><span class="control-label" ita="Annulla" eng="Cancel">Annulla</span></button>' +
                            '<button id="btnForward-' + self.collection.id + '" type="button" class="btn btn-info"><span class="control-label" ita="Si" eng="Yes">Si</span></button>' +
                            '<button id="btnOk-' + self.collection.id + '" type="button" class="btn btn-danger"><span class="control-label" ita="Si" eng="Yes">Si</span></button>' +
                        '</div>' +
                    '</div>' +
                '</div>' +
            '</div>'
        );
    },
    draw: function () {
        var self = this;
        $("#btnForward-" + self.collection.id).toggle();
        if (self.collection.doubleConfirm) {
            $("#btnForward-" + self.collection.id).toggle();
            $("#btnOk-" + self.collection.id).toggle();
            $("#modalIcon-" + self.collection.id).attr("class", "fa fa-question-circle fa-2x cCiano");
        }
        else {
            if (this.type == "ERR") {
                $("#modalIcon-" + self.collection.id).attr("class", "fa fa-exclamation-triangle fa-2x cRosso");
            }
            else {
                $("#modalIcon-" + self.collection.id).attr("class", "fa fa-question-circle fa-2x cPrimary");
            }
        }
        $("#btnOk-" + self.collection.id).click(function () {
            window[self.collection.onConfirm]();
            $("#confirm-" + self.collection.id).modal("hide");
        });
        if (this.hideTitle) {
            $("#header-" + self.collection.id).hide();
        } else {
            $("#header-" + self.collection.id).show();
        }
        $("#btnForward-" + self.collection.id).click(function () {
            $("#btnForward-" + self.collection.id).toggle();
            $("#btnOk-" + self.collection.id).toggle()
            $("#messageTitle-" + self.collection.id).html("").append(self.collection.doubleConfirm);
            $("#modalIcon-" + self.collection.id).attr("class", "fa fa-exclamation-triangle fa-2x cRosso");
        });
        $("#confirm-" + self.collection.id).on("shown.bs.modal", function () {
            if ($("#modalIcon-" + self.collection.id).attr("class").indexOf("cRosso") > -1 && self.collection.doubleConfirm != null) {
                $("#btnForward-" + self.collection.id).toggle();
                $("#btnOk-" + self.collection.id).toggle();
                $("#modalIcon-" + self.collection.id).attr('class', 'fa fa-question-circle fa-2x cCiano');
                $("#messageTitle-" + self.collection.id).html("").append(self.collection.defaultConfirm);
            }
        });
    },
    show: function () {
        this.initialize();
        initLang();
        $("#confirm-" + this.collection.id).modal();
    },
    hide: function () {
        $("#confirm-" + this.collection.id).modal("hide");
    }
});

var notify = Backbone.View.extend({
    title: "",
    text: "",
    type: "",
    initialize: function () {
        this.render();
        this.draw()
    },
    render: function () {
        var self = this;
        $(
            '<div id="notify" class="modal fade">' +
                    '<div class="modal-dialog">' +
                        '<div class="modal-content">' +
                        '<div class="modal-header">' +
                            '<p><i class="fa fa-times pull-right" data-dismiss="modal"></i></p>' +
                            '<h3><span class="control-label" id="headerTitle">' + self.collection.title + '</span></h4>' +
                        '</div>' +
                        '<div class="modal-body">' +
                            '<div class="row">' +
                                '<div class="col-sm-1 col-xs-1"><i id="modalIcon" class="fa fa-exclamation-triangle fa-2x cRosso"></i></div>' +
                                '<div class="col-sm-11 col-xs-11">' +
                                    '<b id="messageHeader"><h4><b><span class="control-label" ita="Attenzione" eng="Warning"></span></b></h4></b>' +
                                    '<h5><p id="messageTitle">' + self.collection.text + '</p></h5>' +
                                '</div>' +
                            '</div>' +
                        '</div>' +
                        '<div class="modal-footer">' +
                            '<button type="button" class="btn btn-default" data-dismiss="modal">OK</button>' +
                        '</div>' +
                    '</div>' +
                '</div>' +
            '</div>'
        ).appendTo(document.body);
        //initLang('notify', undefined);
    },
    draw: function () {
        if (this.type=="ERR") {
            $("#modalIcon").attr("class", "fa fa-exclamation-triangle fa-2x cRosso");
        }
        else
        {
            $("#modalIcon").attr("class", "fa fa-info-circle fa-2x cVerde");
        }
        $("#headerTitle").html("").append(this.title);
        $("#messageTitle").html("").append(this.text);
    },
    show: function () {
        this.draw();
        $("#notify").modal();
    },
    hide: function () {
        $("#notify").modal("hide");
    }
});
$(function () {
    /* {initialize} system-objects */
    appAlert = new confirm({
        collection: {
            id: "container_alert",
            defaultConfirm: null,
            doubleConfirm: null,
            onConfirm: null,
            title: null
        }
    });
    appNotify = new notify({
        collection: {
            title: null,
            text: null,
            type: null
        }
    });
});


