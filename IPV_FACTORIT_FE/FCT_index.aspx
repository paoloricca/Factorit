<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="FCT_index.aspx.vb" Inherits="WebManager.FCT_index" %>
<%@ Register Src="UC/TopNav.ascx" TagName="TopNav" TagPrefix="UC" %><%@ Register Src="UC/Footer.ascx" TagName="Footer" TagPrefix="UC" %><%@ Register Src="UC/DivTutorialWelcome.ascx" TagName="TW" TagPrefix="UC" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    
    <!-- init fonts -->
    <link href='https://fonts.googleapis.com/css?family=Anton|Oswald|Roboto+Slab' rel='stylesheet' type='text/css' />
    <link href='https://fonts.googleapis.com/css?family=Roboto:100,300,400,700,900' rel='stylesheet' type='text/css' />
    <link href="http://db.onlinewebfonts.com/c/866186b8ca0d1844fc7e2771c2d9ce6c?family=HelveticaBold" rel="stylesheet" type="text/css" />
    <link href="http://db.onlinewebfonts.com/c/bec9cfcd690948400517b31821c873e1?family=Helvetica" rel="stylesheet" type="text/css" />
    <link href="http://db.onlinewebfonts.com/c/7ff4438405bfb9fe87b606ca356ba6a0?family=Roboto+Condensed" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" type="text/css" href="css/jquery-ui.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.10.0/css/bootstrap-select.min.css" />

    <!-- init app scripts -->
    <script src="js/FCT/jquery-2.1.4.min.js"></script>
    <script src="js/FCT/underscore-min.js"></script>
    <script src="js/FCT/backbone-min.js"></script>
    <script src="js/FCT/utility.js"></script>
    <!-- init style-sheet -->
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
    <script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
    <script src="js/FCT/datepicker-it.js"></script>
    <!-- Init lang -->
    <script src="utility/app.init.lang.js"></script>
    <!-- init app controls -->
    <script src="controls/app.init.alert.js"></script>
    <script src="controls/app.init.error.js"></script>
    <script src="controls/app.init.loader.js"></script>
    <!-- init model session -->
    <script src="models/app.model.session.js"></script>
    <!-- Init storage -->    
    <script src="utility/app.init.storage.js"></script>
    <!-- init config -->
    <script src="js/FCT/config/app.config.js"></script>
    <!-- Init errors -->
    <script src="errors/app.error.print.js"></script>

    <asp:Literal ID="ltrHtmlHeader" runat="server" EnableViewState="false"></asp:Literal>

    <!-- init style-sheet -->
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="css/wrapper.css" />



    <script type="text/javascript">
        var arrExcluded = '';
        function setExcluded(IdPratica, IsDeregulation) {
            try {
                spinner.show();
                var terms = {
                    IdPratica: IdPratica,
                    IsDeregulation: IsDeregulation
                };
                var formData = new FormData();
                formData.append("terms", JSON.stringify(terms));
                userStorage = JSON.parse(localStorage.getItem("session"));
                $.ajax({
                    url: appConfig.apiPrefix + 'FCT_setExcluded',
                    data: formData,
                    type: 'POST',
                    contentType: false,
                    processData: false,
                    headers: {
                        lang: userStorage.lang,
                        //licencekey: "testLicenceKey0123"
                    },
                    success: function (data, textStatus, jqXHR) {
                        if (textStatus == "success") {
                        }
                        spinner.hide();
                    },
                    error: function () {
                        displayError(appMessage.defaultError);
                    }
                });
            }
            catch (err) {
                displayError(appMessage.defaultError);
            }
        }
        function post_dainviare_confirm() {
            try {
                spinner.show();
                var terms = {
                    dateFrom: $('#txt_dateFrom').val(),
                    dateTo: $('#txt_dateTo').val()
                };
                var formData = new FormData();
                formData.append("terms", JSON.stringify(terms));

                userStorage = JSON.parse(localStorage.getItem("session"));
                $.ajax({
                    url: appConfig.apiPrefix + 'FCT_daspedire',
                    data: formData,
                    type: 'POST',
                    contentType: false,
                    processData: false,
                    headers: {
                        lang: userStorage.lang,
                    },
                    success: function (data, textStatus, jqXHR) {
                        if (textStatus == "success") {
                            appNotify.title = "Invio pratiche";
                            appNotify.text = "Elaborazione eseguita con successo.";
                            appNotify.show();
                        }
                        spinner.hide();
                    },
                    error: function () {
                        displayError(appMessage.defaultError);
                    }
                });
            }
            catch (err) {
                displayError(appMessage.defaultError);
            }

        }
        function load_inviate() {
            $(function () {
                try {
                    /* 
                    Carico tutte le pratiche che:
                        - sono state elaborate (IsInit = 1) ed invitate a Factorit (IsSent = 1)
                    */
                    spinner.show();
                    var terms = {
                        dateFrom: $('#txt_dateFrom').val(),
                        dateTo: $('#txt_dateTo').val(),
                        excluded: arrExcluded,
                        option: 0
                    };
                    var header = $("#container_header");
                    var container = $("#container_pratiche");
                    userStorage = JSON.parse(localStorage.getItem("session"));
                    $.ajax({
                        url: appConfig.apiPrefix + 'FCT_inviate',
                        dataType: 'json',
                        contentType: 'application/json',
                        data: terms,
                        type: 'GET',
                        headers: {
                            lang: userStorage.lang,
                            //licencekey: "testLicenceKey0123"
                        },
                        success: function (data) {
                            /* printing pratiche-header */
                            header.empty();
                            var content_header = '';
                            content_header += '<tr>';
                            content_header += '<th>#</th>';
                            content_header += '<th>Protocollo</th>';
                            content_header += '<th>Evento</th>';
                            content_header += '<th>Debitore</th>';
                            content_header += '<th>Partenza</th>';
                            content_header += '<th>Importo</th>';
                            content_header += '<th>Acconto</th>';
                            content_header += '<th>Saldo</th>';
                            content_header += '<th>Divisa</th>';
                            content_header += '</tr>';
                            header.append(content_header);

                            container.empty();
                            if (data.length > 0) {
                                $('#countPratiche').html('Pratiche trovate: ' + data.length);
                                /* printing pratiche-content */
                                $.each(data, function (key, pratica) {
                                    var accontoScadenza = "";
                                    if (pratica.accontoScadenza != null) {
                                        accontoScadenza = "<br /><h6>SC. " + pratica.accontoScadenza + "</h6>";
                                    }
                                    var saldoScadenza = pratica.saldoScadenza;
                                    if (pratica.saldoScadenza != null) {
                                        saldoScadenza = "<br /><h6>SC. " + pratica.saldoScadenza + "</h6>";
                                    }
                                    //var cssIsDeregulation = '';
                                    //var cssIsChecked = 'checked="checked"';
                                    //if (pratica.isDeregulation == 'True') {
                                    //    cssIsDeregulation = ' class="danger"';
                                    //    cssIsChecked = '';
                                    //    arrExcluded += ';' + pratica.IdPratica;
                                    //}
                                    var content = '<tr>';
                                    //content += '<td><input class="select" type="checkbox" ' + cssIsChecked + ' value="' + pratica.IdPratica + '"></td>';
                                    content += '<td></td>';
                                    content += '<td>' + pratica.numPratica + '</td>';
                                    content += '<td>' + pratica.evento + '</td>';
                                    content += '<td>' + pratica.debitore + '</td>';
                                    content += '<td>' + pratica.dataPartenza + '</td>';
                                    content += '<td>' + pratica.importo + '</td>';
                                    content += '<td>' + pratica.acconto + accontoScadenza + '</td>';
                                    content += '<td>' + pratica.saldo + saldoScadenza + '</td>';
                                    content += '<td>' + pratica.divisa + '</td>';
                                    content += '</tr>';
                                    container.append(content);
                                });
                                $('#container_pratiche .select').click(function () {
                                });
                                //initLang();
                            }
                            else {
                                $('#countPratiche').html('Pratiche trovate: 0');
                                //alert("no data");
                            }
                            spinner.hide();
                        },
                        error: function () {
                            displayError(appMessage.defaultError);
                        }
                    });
                }
                catch (err) {
                    displayError(appMessage.defaultError);
                }
            });
        }
        $(function () {
            $('input[type=radio][name=optradio]').change(function () {
                $('#btn-elabora').removeClass('btn btn-primary').addClass('btn btn-primary disabled');
                $('#flussoRitorno').collapse("hide");
                switch (this.value) {
                    case '0': load_daelaborare(); break;
                    case '1': load_dainviare(); break;
                    case '2': 
                        load_inviate(); 
                        $('#flussoRitorno').collapse('show');
                        break;
                }
            });
            $('#btn-elabora').click(function () {
                switch ($("input[name='optradio']:checked").val()) {
                    case '0': post_daelaborare(); break;
                    case '1': post_dainviare(); break;
                }
            });
            $('#btn-cerca-daelaborare').click(function () {
                switch ($("input[name='optradio']:checked").val()) {
                    case '0': load_daelaborare(); break;
                    case '1': load_dainviare(); break;
                    case '2': load_inviate(); break;
                }
            });
            function post_daelaborare () {
                try {
                    spinner.show();
                    var terms = {
                        dateFrom: $('#txt_dateFrom').val(),
                        dateTo: $('#txt_dateTo').val(),
                        excluded: arrExcluded
                    };
                    var formData = new FormData();
                    formData.append("terms", JSON.stringify(terms));

                    userStorage = JSON.parse(localStorage.getItem("session"));
                    $.ajax({
                        url: appConfig.apiPrefix + 'FCT_daelaborare',
                        data: formData,
                        type: 'POST',
                        contentType: false,
                        processData: false,
                        headers: {
                            lang: userStorage.lang,
                            //licencekey: "testLicenceKey0123"
                        },
                        success: function (data, textStatus, jqXHR) {
                            if (textStatus == "success") {
                                $("#opt_1").prop("checked", true);
                                load_dainviare();
                            }
                            spinner.hide();
                        },
                        error: function () {
                            displayError(appMessage.defaultError);
                        }
                    });
                }
                catch (err) {
                    displayError(appMessage.defaultError);
                }
            }
            function post_dainviare() {
                appAlert.collection.defaultConfirm = appMessage.defaultConfirm;
                appAlert.collection.doubleConfirm = appMessage.doubleConfirm;
                appAlert.collection.onConfirm = "post_dainviare_confirm";
                appAlert.collection.title = "Invio pratiche";
                appAlert.show();
            }
            function load_dainviare() {
                try {
                    /* 
                    Carico tutte le pratiche che:
                        - sono state elaborate (IsInit = 1) e non ancora inviate (IsSent = 0)
                    */
                    spinner.show();
                    var terms = {
                        dateFrom: $('#txt_dateFrom').val(),
                        dateTo: $('#txt_dateTo').val(),
                        excluded: arrExcluded,
                        option: 0
                    };
                    var header = $("#container_header");
                    var container = $("#container_pratiche");
                    userStorage = JSON.parse(localStorage.getItem("session"));
                    $.ajax({
                        url: appConfig.apiPrefix + 'FCT_dainviare',
                        dataType: 'json',
                        contentType: 'application/json',
                        data: terms,
                        type: 'GET',
                        headers: {
                            lang: userStorage.lang,
                            //licencekey: "testLicenceKey0123"
                        },
                        success: function (data) {
                            /* printing pratiche-header */
                            header.empty();
                            var content_header = '';
                            content_header += '<tr>';
                            content_header += '<th>#</th>';
                            content_header += '<th>Protocollo</th>';
                            content_header += '<th>Debitore</th>';
                            content_header += '<th>Partenza</th>';
                            content_header += '<th>Importo</th>';
                            content_header += '</tr>';
                            header.append(content_header);

                            container.empty();
                            if (data.length > 0) {
                                $('#btn-elabora').removeClass('btn btn-primary disabled').addClass('btn btn-primary');
                                $('#countPratiche').html('Pratiche trovate: ' + data.length);
                                /* printing pratiche-content */
                                $.each(data, function (key, pratica) {
                                    var cssIsDeregulation = '';
                                    var cssIsChecked = 'checked="checked"';
                                    if (pratica.isDeregulation == 'True') {
                                        cssIsDeregulation = ' class="danger"';
                                        cssIsChecked = '';
                                        arrExcluded += ';' + pratica.IdPratica;
                                    }
                                    var content = '<tr' + cssIsDeregulation + '>';
                                    content += '<td><input class="select" type="checkbox" ' + cssIsChecked + ' value="' + pratica.IdPratica + '"></td>';
                                    content += '<td>' + pratica.numPratica + '</td>';
                                    content += '<td>' + pratica.debitore + '</td>';
                                    content += '<td>' + pratica.dataPartenza + '</td>';
                                    content += '<td>' + pratica.importo + '</td>';
                                    content += '</tr>';
                                    container.append(content);
                                });
                                $('#container_pratiche .select').click(function () {
                                    //alert($(this).attr('value'));
                                    if ($(this).prop("checked")) {
                                        arrExcluded = arrExcluded.split(';' + $(this).attr('value')).join('');
                                        $(this).parent().parent('tr').removeClass('danger');
                                        setExcluded($(this).attr('value'), 0);
                                    } else {
                                        arrExcluded += ';' + $(this).attr('value');
                                        $(this).parent().parent('tr').removeClass().addClass('danger');
                                        setExcluded($(this).attr('value'), 1);
                                    }
                                    console.log('arrIdPratiche: ' + arrExcluded);
                                });
                                $('#btn-elabora').removeClass('btn btn-primary disabled').addClass('btn btn-primary');
                                //initLang();
                            }
                            else {
                                $('#countPratiche').html('Pratiche trovate: 0');
                                $('#btn-elabora').removeClass('btn btn-primary').addClass('btn btn-primary disabled');
                            }
                            spinner.hide();
                        },
                        error: function () {
                            displayError(appMessage.defaultError);
                        }
                    });
                }
                catch (err) {
                    displayError(appMessage.defaultError);
                }
            }
            function load_daelaborare() {
                try {
                    /* 
                    Carico tutte le pratiche che:
                        - non sono mai state elaborate (IsInit = 0), OR
                        - elaborate AND (@TotAvereIdee è diverso da @TotAvereIdeeOld)
                    */
                    spinner.show();
                    var terms = {
                        dateFrom: $('#txt_dateFrom').val(),
                        dateTo: $('#txt_dateTo').val(),
                        excluded: arrExcluded
                    };
                    var header = $("#container_header");
                    var container = $("#container_pratiche");
                    userStorage = JSON.parse(localStorage.getItem("session"));
                    $.ajax({
                        url: appConfig.apiPrefix + 'FCT_daelaborare',
                        dataType: 'json',
                        contentType: 'application/json',
                        data: terms,
                        type: 'GET',
                        headers: {
                            lang: userStorage.lang,
                            //licencekey: "testLicenceKey0123"
                        },
                        success: function (data) {
                            /* printing pratiche-header */
                            header.empty();
                            var content_header = '';
                            content_header += '<tr>';
                            content_header += '<th>#</th>';
                            content_header += '<th>Protocollo</th>';
                            content_header += '<th>Debitore</th>';
                            content_header += '<th>Partenza</th>';
                            content_header += '<th>Importo</th>';
                            content_header += '</tr>';
                            header.append(content_header);

                            container.empty();
                            if (data.length > 0) {
                                $('#btn-elabora').removeClass('btn btn-primary disabled').addClass('btn btn-primary');
                                $('#countPratiche').html('Pratiche trovate: ' + data.length);
                                /* printing pratiche-content */
                                $.each(data, function (key, pratica) {
                                    var content = '<tr>';
                                    content += '<td><input class="select" type="checkbox" checked="checked" value="' + pratica.IdPratica + '"></td>';
                                    content += '<td>' + pratica.numPratica + '</td>';
                                    content += '<td>' + pratica.debitore + '</td>';
                                    content += '<td>' + pratica.dataPartenza + '</td>';
                                    content += '<td>' + pratica.importo + '</td>';
                                    content += '</tr>';
                                    container.append(content);
                                });
                                $('#container_pratiche .select').click(function () {
                                    //alert($(this).attr('value'));
                                    if ($(this).prop("checked")) {
                                        arrExcluded = arrExcluded.split(';' + $(this).attr('value')).join('');
                                        $(this).parent().parent('tr').removeClass('danger');
                                    } else {
                                        arrExcluded += ';' + $(this).attr('value');
                                        $(this).parent().parent('tr').removeClass().addClass('danger');
                                    }
                                    console.log('arrIdPratiche: ' + arrExcluded);
                                });
                                $('#btn-elabora').removeClass('btn btn-primary disabled').addClass('btn btn-primary');
                                //initLang();
                            }
                            else {
                                $('#countPratiche').html('Pratiche trovate: 0');
                                $('#btn-elabora').removeClass('btn btn-primary').addClass('btn btn-primary disabled');
                            }
                            spinner.hide();
                        },
                        error: function () {
                            displayError(appMessage.defaultError);
                        }
                    });
                }
                catch (err) {
                    displayError(appMessage.defaultError);
                }
            }
        });
    </script>

</head>
    <body>
     <form id="form1" runat="server">
    <!-- START TOP SECTION -->
	<div class="container_12">
	    <UC:TopNav id="TopNav" runat="server"></UC:TopNav>
        <div class="clear"></div>
	</div>
	<!-- END TOP SECTION -->

    <!-- START MEDIUM SECTION -->
	<div class="container_12" id="help">
        <UC:TW id="TW" runat="server"></UC:TW>
	</div>
	<!-- END MEDIUM SECTION -->
   
	<!-- START BOTTOM SECTION -->
	<div class="container_12" style="border:0px solid black;width:90%">
        <!--colonna spaziatrice-->
		<div class="grid_12" style="border:0px solid black;width:100%">
            <div class="work">                
                <div id="container_alert"></div>
                <div id="container_error"></div>
                <div id="container_loader"></div>
                <div class="container-fluid">
                    <h2 class="fBase">
                        <strong>Factorit</strong> / Scambio dati Cedenti
                    </h2>
                    <div class="col-xs-12">
                        <div class="form-inline">
                            <label class="radio-inline"><input id="opt_0" type="radio" name="optradio" value="0" checked="checked">Da elaborare</label>
                            <label class="radio-inline"><input id="opt_1" type="radio" name="optradio" value="1">Pronte da inviare</label>
                            <label class="radio-inline"><input id="opt_2" type="radio" name="optradio" value="2">Inviate a FACTORIT</label>
                            <hr />
                        </div>
                    </div>
                    <!-- START, Caricamento flusso di ritorno. -->
                    <div id="flussoRitorno" class="container collapse" style="padding:0; margin:0;">
                    <div class="col-xs-12">
                        <h4 class="fBase">
                            <strong>
                                Caricamento flusso di ritorno.
                            </strong>
                        </h4>
                        <h6 class="fBase" style="color:orangered">
                            <strong>
                                <asp:Label runat="server" id="StatusLabel" />
                            </strong>
                        </h6>
                    </div>
                    <div class="col-xs-10">
                        <asp:FileUpload id="FileUploadControl" runat="server" CssClass="btn btn-default" />
                    </div>
                    <div class="col-xs-2">
                        <asp:Button runat="server" id="UploadButton" CssClass="btn btn-primary pull-right" text="Carica tracciato" onclick="UploadButton_Click" />
                    </div>
                    <div class="col-xs-12">
                        <hr />
                    </div>
                    </div>
                    <!-- END, Caricamento flusso di ritorno. -->
                    <div class="col-xs-12">
                        <form class="form-inline">
                            <div class="form-group">
                                <input runat="server" type="text" class="form-control data" id="txt_dateFrom" placeholder="Es: 01/01/2016" />
                            </div>
                            <div class="form-group">
                                <input runat="server" type="text" class="form-control data" id="txt_dateTo" placeholder="Es: 17/05/2016" />
                            </div>
                            <a href="#" class="MyButton" id="btn-cerca-daelaborare">
                                <strong>
                                    CERCA
                                </strong>
                            </a>
                        </form>
                    </div>
                    <div class="col-xs-12">
                        <hr />
                        <h5 id="countPratiche"></h5>
                        <a href="#" class="MyButton disabled" id="btn-elabora">
                            <strong>
                                ELABORA
                            </strong>
                        </a>
                    </div>
                    <div class="col-xs-12 bg-white" style="padding:14px; margin-top:10px;">
                        <table class="table table-hover bg-white">
                            <thead id="container_header"></thead>
                            <tbody id="container_pratiche"></tbody>

                        </table>
                    </div>
                </div>
                <script type="text/javascript">
                    $(function () {
                        $.datepicker.setDefaults($.datepicker.regional['it']);
                        $(".data:input").datepicker();
                        $('[data-toggle="tooltip"]').tooltip();
                    });
                </script>
                <!-- end import-->
            </div>	
	   	</div>
        <!-- END TESTIMONIAL SECTION -->		
	   	<div class="clear"></div>
   	</div>
   	<!-- END BOTTOM SECTION -->
   
   	<!-- START FOOTER -->
   	<div class="container_12">
	   <UC:Footer id="Footer" runat="server"></UC:Footer>
	</div>
	<!-- END FOOTER -->


    </form>
    </body>
</html>
