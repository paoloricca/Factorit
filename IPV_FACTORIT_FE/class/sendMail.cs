using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Configuration;
using System.Net;

namespace IPV_FACTORIT_FE.sendMail
{
	public class sendMail
	{

        /// <summary>
        /// Invia una mail con i parametri forniti multi email usano il ; per dividerle
        /// </summary>
        public static bool SendSystemEmail(string from, string to, string bcc, string subject, string body, string FilePathForAttach, bool EmbedAttachInBody, bool UseHtmlBody)
        {
            dynamic result = false;
            try
            {
                System.Net.Mail.MailMessage objMsg = new System.Net.Mail.MailMessage();
                if ((from == null))
                {
                    objMsg.From = new System.Net.Mail.MailAddress(ConfigurationManager.AppSettings["WS.SmtpUser"]);
                }
                else
                {
                    objMsg.From = new System.Net.Mail.MailAddress(from);
                }

                int ContaEmails = to.Split(';').Length;
                if (ContaEmails == 1)
                {
                    objMsg.To.Add(to);
                }
                else
                {
                    objMsg.To.Add(to.Split(';')[0]);
                    for (int i = 0; i <= ContaEmails - 1; i++)
                    {
                        if (i > 0)
                        {
                            objMsg.CC.Add(to.Split(';')[i]);
                        }
                    }
                }

                if ((bcc != null))
                {
                    ContaEmails = bcc.Split(';').Length;
                    for (int i = 0; i <= ContaEmails - 1; i++)
                    {
                        objMsg.Bcc.Add(bcc.Split(';')[i]);
                    }
                }

                MemoryStream ms = null;
                if ((FilePathForAttach != null))
                {
                    if (File.Exists(FilePathForAttach))
                    {
                        ms = new MemoryStream(File.ReadAllBytes(FilePathForAttach));
                    }
                }

                objMsg.Subject = subject;
                objMsg.Body = body;
                objMsg.IsBodyHtml = UseHtmlBody;

                if ((ms != null))
                {
                    if (EmbedAttachInBody)
                    {
                        objMsg.IsBodyHtml = true;

                        //objMsg.Body = System.Text.Encoding.UTF8.GetString(ms.ToArray())
                        objMsg.Body = System.Text.Encoding.GetEncoding("iso-8859-1").GetString(ms.ToArray());

                        //lettere accentate
                        objMsg.Body = objMsg.Body.Replace("à", "&agrave;");
                        objMsg.Body = objMsg.Body.Replace("è", "&egrave;");
                        objMsg.Body = objMsg.Body.Replace("ì", "&igrave;");
                        objMsg.Body = objMsg.Body.Replace("ò", "&ograve;");
                        objMsg.Body = objMsg.Body.Replace("ù", "&ugrave;");
                        //caratteri speciali
                        objMsg.Body = objMsg.Body.Replace("€", "&euro;");
                    }
                    else
                    {
                        System.Net.Mail.Attachment attach = new System.Net.Mail.Attachment(ms, new FileInfo(FilePathForAttach).Name);
                        attach.ContentId = "contentID";
                        objMsg.Attachments.Add(attach);
                    }
                }

                objMsg.Priority = System.Net.Mail.MailPriority.Normal;
                System.Net.Mail.SmtpClient client = new System.Net.Mail.SmtpClient();
                client.Host = ConfigurationManager.AppSettings["WS.SmtpHost"];
                client.Port = (int)Convert.ToInt64(ConfigurationManager.AppSettings["WS.SmtpPort"]);
                NetworkCredential nc = new NetworkCredential(System.Configuration.ConfigurationManager.AppSettings["WS.SmtpUser"], System.Configuration.ConfigurationManager.AppSettings["WS.SmtpPassword"]);
                client.Credentials = nc;

                //System.Web.HttpContext.Current.Response.Write("<h3>Info Email Inviata</h3>");
                client.Send(objMsg);
                if ((ms != null))
                {
                    ms.Close();
                }

                result = true;
            }
            catch (System.Net.Mail.SmtpException ex)
            {
                //Me.lblLog.Text += vbCrLf & "Errore in fase di invio email.Ci scusiamo per il disagio.<br/> SmtpException " & Convert.ToString(ex.StatusCode) & " - " & ex.Message
                HttpContext.Current.Response.Write("Errore in fase di invio email.Ci scusiamo per il disagio.<br/> SmtpException " + Convert.ToString(ex.StatusCode) + " - " + ex.Message);
                result = false;
            }
            catch (Exception ex)
            {
                //Me.lblLog.Text += vbCrLf & "Errore in fase di invio email.Ci scusiamo per il disagio.<br/> SmtpException " & Convert.ToString(ex.Message) & " - " & ex.StackTrace
                HttpContext.Current.Response.Write("Errore in fase di invio email.Ci scusiamo per il disagio.<br/> SmtpException " + Convert.ToString(ex.Message) + " - " + ex.StackTrace);
                result = false;
            }

            return result;
        }

        public static bool SendSystemEmail(string to, string subject, string body)
        {
            return SendSystemEmail(null, to, null, subject, body, null, false, false);
        }

        //=======================================================
        //Service provided by Telerik (www.telerik.com)
        //Conversion powered by NRefactory.
        //Twitter: @telerik
        //Facebook: facebook.com/telerik
        //=======================================================

	}
}