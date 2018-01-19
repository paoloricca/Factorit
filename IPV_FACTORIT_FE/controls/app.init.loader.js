var loader = Backbone.View.extend({
    initialize: function () {
        this.render();
        this.draw()
    },
    render: function () {
        $('<div class="col-xs-12" style="background-color:#fff; border:1px solid #e1e1e1;">' +
            '<h6 class="control-label col-xs-12 text-warning"><i class="fa fa-circle-o-notch fa-lg fa-pulse pull-left"></i>' + appMessage.loader + '</h6>' +
            '</div>').appendTo($("#" + this.collection.id));
    },
    draw: function () {
    },
    show: function () {
        this.draw();
        $("#" + this.collection.id).show();
    },
    hide: function () {
        $("#" + this.collection.id).hide();
    }
});
/* {initialize} system-objects */
$(function () {
    spinner = new loader({
        collection: {
            id: "container_loader",
        }
    });
});
