<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ipv_factorit_fe_index.aspx.cs" EnableViewState="true" 
    EnableEventValidation="false"
    Inherits="IPV_FACTORIT_FE.ipv_factorit_fe_index" %>
<!DOCTYPE html>
<html>
    <head runat="server">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title></title>
    <!-- init fonts -->
    <link href='https://fonts.googleapis.com/css?family=Anton|Oswald|Roboto+Slab' rel='stylesheet' type='text/css' />
    <link href='https://fonts.googleapis.com/css?family=Roboto:300,300,400,700,900' rel='stylesheet' type='text/css' />
    <link rel="stylesheet" type="text/css" href="css/jquery-ui.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-select/1.10.0/css/bootstrap-select.min.css" />

    <!-- init app scripts -->
    <script src="js/jquery-2.1.4.min.js"></script>
    <script src="js/underscore-min.js"></script>
    <script src="js/backbone-min.js"></script>
    <script src="js/utility.js"></script>

    <!-- init style-sheet -->
    <script src="http://code.jquery.com/ui/1.9.1/jquery-ui.js"></script>
    <script src="js/datepicker-it.js"></script>
    <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>

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
    <script src="config/app.config.js"></script>
    <!-- Init errors -->
    <script src="errors/app.error.print.js"></script>

    <!-- init style-sheet -->
    <link href="//maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
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
            var IdModalitaFactorit = $("input[name='opt-modalita-factorit']:checked").val();
            var terms = {
                dateFrom: $('#txt_dateFrom').val(),
                dateTo: $('#txt_dateTo').val(),
                IdModalitaFactorit: IdModalitaFactorit
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
                    $("#opt_2").prop("checked", true);
                    load_inviate();
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
    function showResponseResult() {
        $(function () {
            appNotify.title = 'Importazione flusso di ritorno';
            appNotify.text = 'Importazione flusso eseguita con successo.';
            appNotify.type = 'INFO';
            appNotify.show();
        });
    }
    function load_inviate(statoPratica) {
        $(function () {
            try {
                /* 
                Carico tutte le pratiche che:
                    - sono state elaborate (IsInit = 1) ed invitate a Factorit (IsSent = 1)
                */
                var IdModalitaFactorit = $("input[name='opt-modalita-factorit']:checked").val();
                spinner.show();
                var terms = {
                    dateFrom: $('#txt_dateFrom').val(),
                    dateTo: $('#txt_dateTo').val(),
                    excluded: arrExcluded,
                    option: 0,
                    statoPratica: statoPratica,
                    IdModalitaFactorit: IdModalitaFactorit
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
                        content_header += '<tr style="background-color:#f1f1f1;">';
                        content_header += '<th class="text-center">#</th>';
                        content_header += '<th>Protocollo</th>';
                        content_header += '<th>Debitore</th>';
                        content_header += '<th>Partenza</th>';
                        content_header += '<th>Data invio</th>';
                        content_header += '<th>Evento</th>';
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
                                var acconto = pratica.acconto;
                                var tipoAccettazione = "";
                                if (pratica.tipoAccettazione == "P") {
                                    tipoAccettazione = "Prosoluto con riserva";
                                } else if (pratica.tipoAccettazione == "S") {
                                    tipoAccettazione = "Prosolvendo";
                                } else {
                                    tipoAccettazione = "Tipo accettazione non ancora disponibile";
                                }
                                if (pratica.accontoScadenza != null) {
                                    if (pratica.AccontoIsIncassoData != "") {
                                        accontoScadenza = "<br /><h6 class='incassata'>Sc. " + pratica.accontoScadenza + "</h6>";
                                    } else {
                                        accontoScadenza = "<br /><h6 class='rifiutata'>Sc. " + pratica.accontoScadenza + "</h6>";
                                    }
                                } else {
                                    if (pratica.accontoRicevuto != "") {
                                        acconto = "<del>" + pratica.accontoRicevuto + "</del><br /><h6 class='ricevuto'>Gi&agrave ricevuto</h6>";
                                    } else {
                                        acconto = "<h6 class='ricevuto'>Nessun acconto</h6>";
                                    }
                                }
                                var saldoScadenza = pratica.saldoScadenza;
                                if (pratica.saldoScadenza != null) {
                                    if (pratica.SaldoIsIncassoData != "") {
                                        saldoScadenza = "<br /><h6 class='incassata'>Sc. " + pratica.saldoScadenza + "</h6>";
                                    } else {
                                        saldoScadenza = "<br /><h6 class='rifiutata'>Sc. " + pratica.saldoScadenza + "</h6>";
                                    }
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
                                content += '<td class="text-center"><i data-toggle="tooltip" data-placement="right" title="' + tipoAccettazione + '" class="fa fa-circle ' + pratica.stato + '"></i></td>';
                                content += '<td>' + pratica.numPratica + '</td>';
                                content += '<td>' + pratica.debitore + '</td>';
                                content += '<td>' + pratica.dataPartenza + '</td>';
                                content += '<td>' + pratica.dataInvio + '</td>';
                                content += '<td>' + pratica.evento + '</td>';
                                content += '<td>' + pratica.importo + '</td>';
                                content += '<td>' + acconto + accontoScadenza + '</td>';
                                content += '<td>' + pratica.saldo + saldoScadenza + '</td>';
                                content += '<td>' + pratica.divisa + '</td>';
                                content += '</tr>';
                                container.append(content);
                            });
                            $('#container_pratiche .select').click(function () {
                            });
                            $('[data-toggle="tooltip"]').tooltip();
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
        $('input[type=radio][name=opt-modalita-factorit]').change(function () {
            $('#txtIDModalitaFactorit').val($("input[name='opt-modalita-factorit']:checked").val());
            $('#btn-elabora').hide();
            $('#flussoRitorno').collapse("hide");
            $('#legenda').hide();
            $('#container-stato-pratica').hide();
            switch ($("input[name='optradio']:checked").val()) {
                case '0': load_daelaborare(); break;
                case '1': load_dainviare(); break;
                case '2': load_inviate();
                    $('#flussoRitorno').collapse('show');
                    $('#legenda').show();
                    $('#container-stato-pratica').show();
                    break;
            } 
        });
        $('input[type=radio][name=optradio]').change(function () {
            $('#btn-elabora').hide();
            $('#flussoRitorno').collapse("hide");
            $('#legenda').hide();
            $('#container-stato-pratica').hide();
            switch (this.value) {
                case '0': load_daelaborare(); break;
                case '1': load_dainviare(); break;
                case '2':
                    load_inviate();
                    $('#flussoRitorno').collapse('show');
                    $('#legenda').show();
                    $('#container-stato-pratica').show();
                    break;
            }
        });
        $('input[type=radio][name=opt-stato-pratica]').change(function () {
            switch (this.value) {
                case '': load_inviate(); break;
                case '0': load_inviate(0); break;
                case '1': load_inviate(1); break;
                case '2': load_inviate(2); break;
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
        function post_daelaborare() {
            try {
                var IdModalitaFactorit = $("input[name='opt-modalita-factorit']:checked").val();
                console.log(IdModalitaFactorit);
                spinner.show();
                var terms = {
                    dateFrom: $('#txt_dateFrom').val(),
                    dateTo: $('#txt_dateTo').val(),
                    excluded: arrExcluded,
                    IdModalitaFactorit: IdModalitaFactorit
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
                var IdModalitaFactorit = $("input[name='opt-modalita-factorit']:checked").val();
                spinner.show();
                var terms = {
                    dateFrom: $('#txt_dateFrom').val(),
                    dateTo: $('#txt_dateTo').val(),
                    excluded: arrExcluded,
                    option: 0,
                    IdModalitaFactorit: IdModalitaFactorit
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
                        content_header += '<th class="text-center">#</th>';
                        content_header += '<th>Protocollo</th>';
                        content_header += '<th>Debitore</th>';
                        content_header += '<th>Partenza</th>';
                        content_header += '<th>Importo</th>';
                        content_header += '</tr>';
                        header.append(content_header);

                        container.empty();
                        if (data.length > 0) {
                            $('#btn-elabora').show();
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
                                content += '<td class="text-center"><input class="select" type="checkbox" ' + cssIsChecked + ' value="' + pratica.IdPratica + '"></td>';
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
                            $('#btn-elabora').show();
                            //initLang();
                        }
                        else {
                            $('#countPratiche').html('Pratiche trovate: 0');
                            $('#btn-elabora').hide();
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
                var IdModalitaFactorit = $("input[name='opt-modalita-factorit']:checked").val();
                spinner.show();
                var terms = {
                    dateFrom: $('#txt_dateFrom').val(),
                    dateTo: $('#txt_dateTo').val(),
                    excluded: arrExcluded,
                    IdModalitaFactorit: IdModalitaFactorit
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
                        content_header += '<th class="text-center">#</th>';
                        content_header += '<th>Protocollo</th>';
                        content_header += '<th>Debitore</th>';
                        content_header += '<th>Partenza</th>';
                        content_header += '<th>Evento</th>';
                        content_header += '<th>Acconto</th>';
                        content_header += '<th>TotAvereIdee</th>';
                        content_header += '<th>TotAvereIdee Ultimo Ec</th>';
                        content_header += '</tr>';
                        header.append(content_header);

                        container.empty();
                        if (data.length > 0) {
                            $('#btn-elabora').show();
                            $('#countPratiche').html('Pratiche trovate: ' + data.length);
                            /* printing pratiche-content */
                            $.each(data, function (key, pratica) {
                                var acconto = pratica.acconto;
                                if (acconto == "") {
                                    acconto = "Nessun acconto"
                                }
                                var content = '<tr>';
                                content += '<td class="text-center"><input class="select" type="checkbox" checked="checked" value="' + pratica.IdPratica + '"></td>';
                                content += '<td>' + pratica.numPratica + '</td>';
                                content += '<td>' + pratica.debitore + '</td>';
                                content += '<td>' + pratica.dataPartenza + '</td>';
                                content += '<td>' + pratica.evento + '</td>';
                                content += '<td>' + acconto + '</td>';
                                content += '<td>' + pratica.TotAvereIdeeOld + '</td>';
                                content += '<td>' + pratica.TotAvereIdeeUltimoEc + '</td>';
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
                            $('#btn-elabora').show();
                            //initLang();
                        }
                        else {
                            $('#countPratiche').html('Pratiche trovate: 0');
                            $('#btn-elabora').hide();
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
            <div id="container_alert"></div>
            <div id="container_error"></div>
            <div id="container_loader"></div>
            <div class="container-fluid">
                <h2 class="fBase">
                    <strong>Factorit</strong> / Scambio dati Cedenti
                </h2>
                <div class="container-fluid">
                    <div class="form-inline">
                        <h6>
                            <label class="radio-inline"><input id="opt_0" type="radio" name="optradio" value="0" checked="checked">Da elaborare</label>
                            <label class="radio-inline"><input id="opt_1" type="radio" name="optradio" value="1">Pronte da inviare</label>
                            <label class="radio-inline"><input id="opt_2" type="radio" name="optradio" value="2">Inviate a FACTORIT</label>
                        </h6>
                    </div>
                </div>
                <!-- START, Importazione flusso di ritorno. -->
                <div id="flussoRitorno" class="container-fluid collapse" style="padding:0; margin:0;">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h5 class="fBase">
                                <strong>
                                    Importazione flusso di ritorno
                                </strong>
                            </h5>
                        </div>
                        <div class="panel-body">
                            <div class="col-xs-12">
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
                        </div>
                    </div>
                </div>
                <!-- END, Importazione flusso di ritorno. -->
                <!-- START, Filtro -->
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <div class="row">
                            <div class="col-xs-2">
                                <h5>
                                    <strong>
                                        FILTRO
                                    </strong>
                                </h5>
                            </div>
                            <div class="col-xs-10">
                                <div class="form-inline pull-right">
                                    <input runat="server" type="hidden" id="txtIDModalitaFactorit" value="1" />
                                    <div class="radio">
                                        <h5>
                                            <label><input value="1" type="radio" name="opt-modalita-factorit" checked="checked"> Banca Popolare di Sondrio</label>
                                        </h5>
                                    </div>
                                    <div class="radio">
                                        <h5>
                                            <label><input value="2" type="radio" name="opt-modalita-factorit"> Mediocredito Italiano</label>
                                        </h5>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="panel-body">
                        <div class="col-xs-6">
                            <div class="form-inline">
                                <h5>
                                    <strong>Estratto Conto</strong>
                                </h5>
                                <input runat="server" type="text" class="form-control data" id="txt_dateFrom" placeholder="Es: 01/01/2016" /> / 
                                <input runat="server" type="text" class="form-control data" id="txt_dateTo" placeholder="Es: 17/05/2016" />
                            </div>
                        </div>
                        <div id="container-stato-pratica" class="col-xs-6" style="display:none;">
                            <div class="form-inline">
                                <h5>
                                    <strong>Stato Pratiche</strong>
                                </h5>
                                <div class="radio">
                                    <label><input value="" type="radio" name="opt-stato-pratica"> Tutte</label>
                                </div>
                                <div class="radio">
                                    <label><input value="0" type="radio" name="opt-stato-pratica"> Non Accettate</label>
                                </div>
                                <div class="radio">
                                    <label><input value="1" type="radio" name="opt-stato-pratica"> Accettate</label>
                                </div>
                                <div class="radio">
                                    <label><input value="2" type="radio" name="opt-stato-pratica"> Rifiutate</label>
                                </div>
                            </div>
                        </div>
                        <div class="col-xs-12" style="margin-top:10px;">
                            <a href="#" class="btn btn-default" id="btn-cerca-daelaborare">
                                <strong>
                                    CERCA
                                </strong>
                            </a>
                            <a href="#" class="btn btn-default" id="btn-elabora" style="display:none;">
                                <strong>
                                    ELABORA
                                </strong>
                            </a>
                        </div>
                    </div>
                </div>
                <!-- END, Filtro -->
                <!-- START, Risultati -->
                <div class="panel panel-default">
                    <div class="panel-body">
                        <div class="col-xs-2">
                            <h4 class="fBase" id="countPratiche"></h4>
                        </div>
                        <div class="col-xs-10 fBase">
                            <h6 id="legenda" class="pull-right" style="display:none;">
                                <strong>Legenda Pratiche</strong>:&nbsp; <i class="fa fa-circle ceduta"></i>&nbsp; Cedute &nbsp; <i class="fa fa-circle accettata"></i>&nbsp; Accettate &nbsp; <i class="fa fa-circle rifiutata"></i>&nbsp; Rifiutate
                            </h6>
                        </div>
                        <div class="col-xs-12" style="margin-top:10px;">
                            <table class="table table-hover table-bordered bg-white">
                                <thead id="container_header"></thead>
                                <tbody id="container_pratiche"></tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            
            <script type="text/javascript">
                $(function () {
                    $.datepicker.setDefaults($.datepicker.regional['it']);
                    $(".data:input").datepicker();
                    $('[data-toggle="tooltip"]').tooltip();
                });
            </script>
        </form>
    </body>
</html>
