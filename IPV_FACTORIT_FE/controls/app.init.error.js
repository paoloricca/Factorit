var error = Backbone.Model.extend({
    defaults: {
        descE: "",
        targetID: ""
    }
});
var errors = Backbone.Collection.extend({
    model: error
});
var view_error = Backbone.View.extend({
    title: null,
    text: "",
    initialize: function () {
        this.render();
    },
    render: function () {
        var self = this;
        //$("#" + self.collection.id).attr("class", "bg-warning");
        $("#" + self.collection.id).html(
            '<i class="fa fa-exclamation-triangle pull-right fa-2x text-danger"></i>' +
            '<h4 id="errorTitle" class="text-danger"></h4>' +
            '<h5 id="errorText" class="col-xs-12"></h5>'
        );
    },
    draw: function () {
        var self = this;
        if (self.title != null) {
            $("#errorTitle").empty().append(self.title);
        } else {
            $('#errorTitle').empty().append("<span class='control-label' ita='Attenzione!' eng='Warning!'>Attenzione</span>");
        }        
        $("#errorText").empty().append(self.text);
    },
    show: function () {
        this.draw();
        $("#" + this.collection.id).show().delay(3000).fadeOut();
    },
    hide: function () {
        $("#" + this.collection.id).hide();
    },
});
/* {initialize} system-objects */
$(function () {
    appError = new view_error({
        collection: {
            id: "container_error",
        }
    });
});