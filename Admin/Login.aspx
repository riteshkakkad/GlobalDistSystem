<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Admin_Login"
    Title="Untitled Page" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<html>
<head>
    <title>Admin</title>
    <style type="text/css">
.bluetable
{
 border: 1px solid #c0c0c0;
 border-spacing: 0px; 
 border-collapse: collapse;
}
.bluetable tr th
{
 background:#f8f8f8;
 padding:5px;
 color: #707070; 
 border-bottom:1px solid #c0c0c0;
 border-right:1px solid #c0c0c0;
text-align:left;
vertical-align:top;

} 
.bluetable tr td
{
 background:white;
 padding:5px;
 border-bottom:1px solid #c0c0c0;
 border-right:1px solid #c0c0c0;
 vertical-align:top;

}

</style>

    <script language="C#" runat="server">
        void Login_Click(Object Src, EventArgs E)
        {
            FormsAuthenticationTicket Authticket = null;
            string hash = null;
            string returnUrl = null;
            HttpCookie Authcookie = null;
            try
            {

                Admin a = AdminDAO.GetAdminByIDPasword(userName.Text, txtPwd.Text);
                if (a != null)
                {
                    Authticket = new FormsAuthenticationTicket(
                                                        1,
                                                        a.AdminID,
                                                        DateTime.Now,
                                                        DateTime.Now.AddMinutes(180),
                                                        false,
                                                        "Admin",
                                                        FormsAuthentication.FormsCookiePath);

                    hash = FormsAuthentication.Encrypt(Authticket);

                    Authcookie = new HttpCookie(FormsAuthentication.FormsCookieName, hash);

                    if (Authticket.IsPersistent) Authcookie.Expires = Authticket.Expiration;

                    Response.Cookies.Add(Authcookie);

                    returnUrl = Request.QueryString["ReturnUrl"];
                    if (returnUrl == null) returnUrl = "ShowBookRequests.aspx";
                    Response.Redirect(returnUrl, false);
                }
                else
                {
                    lblLoginMsg.Text = "Wrong username or password";
                }


            }
            catch (Exception ex)
            {
                lblLoginMsg.Text = "Some Problem";
            }

        }
    </script>

</head>
<body>
    <div style="margin-left: auto; margin-right: auto; width: 400px;height:300px;margin-top:auto;margin-right:auto">
        <form id="Form1" runat="server">
            <table class="bluetable" style="width:400px">
                <tr>
                    <th style="text-align: left">
                        Email
                    </th>
                    <td>
                        <asp:TextBox ID="userName" runat="server" />&nbsp; <span class="error">*</span>
                        <div>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ControlToValidate="userName"
                                Display="Dynamic" ErrorMessage="Login name can't be empty." runat="server" CssClass="error" /></div>
                    </td>
                </tr>
                <tr>
                    <th style="text-align: left">
                        Password
                    </th>
                    <td>
                        <asp:TextBox TextMode="Password" ID="txtPwd" runat="server" />&nbsp; <span class="error">
                            *</span>
                        <div>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ControlToValidate="txtPwd"
                                Display="Dynamic" ErrorMessage="Password can't be left empty." runat="server"
                                CssClass="error" /></div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Label ID="lblLoginMsg" CssClass="error" runat="server" />
                        <asp:Button ID="btnLogin" Text="Login" OnClick="Login_Click" runat="Server" CssClass="buttons"
                            Width="100px" />
                    </td>
                </tr>
            </table>
        </form>
    </div>
   
</body>
</html>
