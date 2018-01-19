using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using Suite.Net.Dati;
using IPV_BU_FACTORIT;
using IPV_FACTORIT_FE.sendMail;

namespace IPV_FACTORIT_FE
{
    public partial class ipv_factorit_fe_index : System.Web.UI.Page
    {
        Database.Sql DB = new Database.Sql(ConfigurationManager.AppSettings["DBConnectionString"].ToString());
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                //DB.Apri(SiNo.Si);
                //Procedura.Strutturata prcGetIncassiTrv = new Procedura.Strutturata("SELECT DISTINCT T_FCT_Pratiche.CodiceDebitore, T_FCT_Pratiche_Ratei.NumPratica, T_FCT_Pratiche.IDPratica FROM T_FCT_Pratiche_Ratei inner join T_FCT_Pratiche on T_FCT_Pratiche_Ratei.idFctPratica = T_FCT_Pratiche.idFctPratica where T_FCT_Pratiche_Ratei.Datascadenza = '2018-01-07 00:00:00.000' group by T_FCT_Pratiche.CodiceDebitore, T_FCT_Pratiche_Ratei.NumPratica, T_FCT_Pratiche.IDPratica", DB.Connessione, DB.Transazione);
                //DataView readerIncassiTrv = (DataView)prcGetIncassiTrv.Esegui(Procedura.Ritorna.DataView);
                //decimal totalePratica = 0;
                //decimal totalePratiche = 0;
                //decimal totaleElaborazione = 0;
                //for (int i = 0; i <= readerIncassiTrv.Count - 1; i++)
                //{
                //    Procedura.Strutturata prcGetTotalePratica = new Procedura.Strutturata("SELECT ( ISNULL((SELECT SUM(importo) FROM T_FCT_Pratiche_Ratei Where Datascadenza = '2018-01-07 00:00:00.000' AND NumPratica = '" + readerIncassiTrv[i]["NumPratica"].ToString() + "' AND (Evento = 'VI' OR Evento = 'AU')), 0) - ISNULL((SELECT SUM(importo) FROM T_FCT_Pratiche_Ratei Where Datascadenza = '2018-01-07 00:00:00.000' AND NumPratica = '" + readerIncassiTrv[i]["NumPratica"].ToString() + "' AND Evento = 'DI'), 0)) AS ImportoPratica", DB.Connessione, DB.Transazione);
                //    totalePratica = (decimal)prcGetTotalePratica.Esegui(Procedura.Ritorna.ValoreScalare);

                //    Tabella T_FCT_Incassi = DB.ImpostaTabella("T_FCT_Incassi");
                //    Riga riga_T_FCT_Incassi = T_FCT_Incassi.ImpostaRiga(Tabella.TipoRiga.Nuova);
                //    riga_T_FCT_Incassi.Colonna("IdModalitaFactorit", 2);
                //    riga_T_FCT_Incassi.Colonna("NumPratica", readerIncassiTrv[i]["NumPratica"].ToString());
                //    riga_T_FCT_Incassi.Colonna("dataScadenza", Convert.ToDateTime("2018-01-07 00:00:00.000"));
                //    riga_T_FCT_Incassi.Colonna("importo", totalePratica);
                //    riga_T_FCT_Incassi.Colonna("dataIncasso", Convert.ToDateTime("2018-01-10 00:00:00.000"));
                //    riga_T_FCT_Incassi.Colonna("segno", "A");
                //    riga_T_FCT_Incassi.Colonna("CodiceDebitore", readerIncassiTrv[i]["CodiceDebitore"].ToString());
                //    riga_T_FCT_Incassi.Colonna("Divisa", "EUR");
                //    riga_T_FCT_Incassi.Colonna("flagFinanziario", "S");
                //    T_FCT_Incassi.AggiungiNuovaRiga(riga_T_FCT_Incassi);
                //    T_FCT_Incassi.Salva(SiNo.Si);

                //    totaleElaborazione += totalePratica;

                //    if (i == 0 || (i > 0 && readerIncassiTrv[i]["CodiceDebitore"].ToString() == readerIncassiTrv[i - 1]["CodiceDebitore"].ToString()))
                //    {
                //        totalePratiche += totalePratica;
                //    }
                //    else
                //    {
                //        totalePratiche = totalePratica;
                //    }

                //    if (i == readerIncassiTrv.Count - 1 || readerIncassiTrv[i]["CodiceDebitore"].ToString() != readerIncassiTrv[i + 1]["CodiceDebitore"].ToString())
                //    {
                //        Tabella Incassi = DB.ImpostaTabella("Incassi");
                //        Riga riga_Incassi = Incassi.ImpostaRiga(Tabella.TipoRiga.Nuova);
                //        riga_Incassi.Colonna("idazienda", readerIncassiTrv[i]["CodiceDebitore"].ToString());
                //        riga_Incassi.Colonna("dataIncasso", Convert.ToDateTime("2018-01-10 00:00:00.000"));
                //        riga_Incassi.Colonna("accrediti", totalePratiche);
                //        riga_Incassi.Colonna("parmodpag", 36);
                //        riga_Incassi.Colonna("estremiincasso", "TRV 07012018");
                //        riga_Incassi.Colonna("ImportoBollo", 0);
                //        Incassi.AggiungiNuovaRiga(riga_Incassi);
                //        Incassi.Salva(SiNo.Si);

                //        Procedura.Strutturata prcGetIncasso = new Procedura.Strutturata("SELECT TOP(1) IdIncasso FROM Incassi WHERE ParModPag = 36 AND EstremiIncasso = 'TRV 07012018' ORDER by idincasso desc", DB.Connessione, DB.Transazione);
                //        int IdIncasso = (int)prcGetIncasso.Esegui(Procedura.Ritorna.ValoreScalare);
                //        //int IdIncasso = 0;

                //        Procedura.Strutturata prcGetPraticheToRelIncassi = new Procedura.Strutturata("SELECT DISTINCT T_FCT_Pratiche.CodiceDebitore, T_FCT_Pratiche_Ratei.NumPratica, T_FCT_Pratiche.IDPratica FROM T_FCT_Pratiche_Ratei inner join T_FCT_Pratiche on T_FCT_Pratiche_Ratei.idFctPratica = T_FCT_Pratiche.idFctPratica WHERE T_FCT_Pratiche_Ratei.Datascadenza = '2018-01-07 00:00:00.000' AND CodiceDebitore = " + readerIncassiTrv[i]["CodiceDebitore"].ToString(), DB.Connessione, DB.Transazione);
                //        DataView reader_PraticheToRelIncassi = (DataView)prcGetPraticheToRelIncassi.Esegui(Procedura.Ritorna.DataView);
                //        for (int r = 0; r <= reader_PraticheToRelIncassi.Count - 1; r++)
                //        {
                //            Procedura.Strutturata prcGetTotalePraticaIncassi = new Procedura.Strutturata("SELECT ( ISNULL((SELECT SUM(importo) FROM T_FCT_Pratiche_Ratei Where Datascadenza = '2018-01-07 00:00:00.000' AND NumPratica = '" + reader_PraticheToRelIncassi[r]["NumPratica"].ToString() + "' AND (Evento = 'VI' OR Evento = 'AU')), 0) - ISNULL((SELECT SUM(importo) FROM T_FCT_Pratiche_Ratei Where Datascadenza = '2018-01-07 00:00:00.000' AND NumPratica = '" + reader_PraticheToRelIncassi[r]["NumPratica"].ToString() + "' AND Evento = 'DI'), 0)) AS ImportoPratica", DB.Connessione, DB.Transazione);
                //            decimal totalePraticaIncassi = (decimal)prcGetTotalePraticaIncassi.Esegui(Procedura.Ritorna.ValoreScalare);

                //            Tabella RelIncassi = DB.ImpostaTabella("RelIncassi");
                //            Riga riga_RelIncassi = RelIncassi.ImpostaRiga(Tabella.TipoRiga.Nuova);
                //            riga_RelIncassi.Colonna("idincasso", IdIncasso);
                //            riga_RelIncassi.Colonna("idpratica", reader_PraticheToRelIncassi[r]["IdPratica"].ToString());
                //            riga_RelIncassi.Colonna("importo", totalePraticaIncassi);
                //            RelIncassi.AggiungiNuovaRiga(riga_RelIncassi);
                //            RelIncassi.Salva(SiNo.Si);
                //        }

                //        totalePratiche = 0;
                //    }
                //}
                //DB.ConfermaTransazione();
            }
            catch (Exception ex)
            {
                //DB.AnnullaTransazione();
            }
            finally
            {
                //DB.Chiudi();
            }
        }
        protected void UploadButton_Click(object sender, EventArgs e)
        {
            try {

                ClientScript.RegisterStartupScript(this.GetType(), "key_load_inviate", "$('#flussoRitorno').collapse('show'); $('#opt_2').prop('checked', true); load_inviate();", true);
                if (FileUploadControl.HasFile)
                {
                    //if (FileUploadControl.PostedFile.FileName.StartsWith("YMFTRV03"))
                    //{
                    //    System.IO.StreamReader sr = new System.IO.StreamReader(FileUploadControl.PostedFile.InputStream);
                    //    string input = string.Empty;
                    //    string IdAgenzia = string.Empty;
                    //    DB.Apri();
                    //    Tabella T_FCT_Adv_Da_Inizializzare = DB.ImpostaTabella("T_FCT_Adv_Da_Inizializzare", SiNo.No);
                    //    do
                    //    {
                    //        input = sr.ReadLine();
                    //        IdAgenzia = input.Substring(18, 16).ToUpper().Trim();
                    //        Riga _T_FCT_Adv_Da_Inizializzare = T_FCT_Adv_Da_Inizializzare.ImpostaRiga(Tabella.TipoRiga.Nuova);
                    //        _T_FCT_Adv_Da_Inizializzare.Colonna("Id", IdAgenzia);
                    //        _T_FCT_Adv_Da_Inizializzare.Colonna("IdModalitaFactorit", 2);
                    //        _T_FCT_Adv_Da_Inizializzare.Colonna("dataApprovazioneFactorit", DateTime.Now.ToString());
                    //        T_FCT_Adv_Da_Inizializzare.AggiungiNuovaRiga(_T_FCT_Adv_Da_Inizializzare);
                    //    } while (sr.Peek() != -1);
                    //    sr.Close();
                    //    DB.Salva();
                    //}
                    if (FileUploadControl.PostedFile.ContentType == "application/octet-stream" || 
                        FileUploadControl.PostedFile.ContentType == "text/plain")
                    {
                        IPV_BU_FACTORIT.pratiche pratiche = new IPV_BU_FACTORIT.pratiche();
                        if (pratiche.elaboraFile(FileUploadControl.PostedFile, txtIDModalitaFactorit.Value))
                        {
                            ClientScript.RegisterClientScriptBlock(this.GetType(), "showResponseResult", "showResponseResult();", true);
                        }
                    }
                    else
                    {
                        StatusLabel.Text = "ATTENZIONE: formato tracciato non corretto.";
                    }
                }
            }
            catch (Exception ex) {

            }
            finally
            {
                DB.Chiudi();
            }
        }
    }
}