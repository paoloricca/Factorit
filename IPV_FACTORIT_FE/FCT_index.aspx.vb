Public Class FCT_index
    Inherits BasePage
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.IDApplicazione = 54 ' ID Factorit da Table [IdeeMain.WMApp]
        If Not Acl.IsAuth() Then Response.Redirect(Conf.SiteUrl & "?WMError=" & Conf.WMError.Accesso_non_autorizzato, True)
        If Not Acl.YouCanRead(Me.IDApplicazione) Then Response.Redirect(Conf.SiteUrl & "?WMError=" & Conf.WMError.Accesso_non_autorizzato, True)
        Me.InitPage()
        Dim DescrApp As String = Conf.TblApp.Select("IDApp=" & Me.IDApplicazione.ToString())(0)("title").ToString()
        Me.InitHtmlHeader("WebManager Application: " & DescrApp, Nothing)
        Me.Help = "<p class='small'>Questa applicazione si occupa di fare la madre di tutte le riconcilliazioni di biglietteria</p><p class='small'>e le informazioni presenti nella nostra banca dati.</p><p class='small'>Spero che il mio lavoro ti sarà utile. Buona(navigazione)</p>"

        ' TABLE [xauAccount]
        ' Acl.IDAccount()
    End Sub

    Protected Sub UploadButton_Click(ByVal sender As Object, ByVal e As EventArgs) Handles UploadButton.Click
        Try
            ClientScript.RegisterStartupScript(Me.GetType(), "key_load_inviate", "load_inviate();", True)
            If FileUploadControl.HasFile Then
                'Me.WriteLog("ContentType: " + FileUploadControl.PostedFile.ContentType)
                If FileUploadControl.PostedFile.ContentType = "text/plain" Then

                Else
                    StatusLabel.Text = "ATTENZIONE: formato tracciato non corretto, allegare un file con estensione (.txt)."
                End If
            End If
        Catch ex As Exception

        End Try
    End Sub
End Class