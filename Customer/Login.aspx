<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/CharterTemplate.master"
    CodeFile="Login.aspx.cs" Inherits="Customer_Login" %>

<%@ Import Namespace="Entities" %>
<%@ Import Namespace="DataAccessLayer" %>
<%@ Import Namespace="BusinessLayer" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="Iesi.Collections" %>
<%@ Import Namespace="NHibernate" %>
<asp:Content ID="Content1" ContentPlaceHolderID="scriptholder" runat="Server">

    <script language="C#" runat="server">
        void Login_Click(Object Src, EventArgs E)
        {
            FormsAuthenticationTicket Authticket = null;
            string hash = null;
            string returnUrl = null;
            HttpCookie Authcookie = null;
            try
            {

                Customer c = CustomerDAO.CheckCustomerByEmailPassword(userName.Text, txtPwd.Text);
                if (c != null)
                {
                    Authticket = new FormsAuthenticationTicket(
                                                        1,
                                                        c.CustomerID.ToString(),
                                                        DateTime.Now,
                                                        DateTime.Now.AddMinutes(180),
                                                        false,
                                                        "Customer",
                                                        FormsAuthentication.FormsCookiePath);

                    hash = FormsAuthentication.Encrypt(Authticket);

                    Authcookie = new HttpCookie(FormsAuthentication.FormsCookieName, hash);

                    if (Authticket.IsPersistent) Authcookie.Expires = Authticket.Expiration;

                    Response.Cookies.Add(Authcookie);

                    returnUrl = Request.QueryString["ReturnUrl"];

                    Session["AgentID"] = null;
                    if (returnUrl == null) returnUrl = "ShowRequests.aspx";

                    Response.Redirect(returnUrl, false);
                }
                else
                {
                    lblLoginMsg.Text = "Wrong email or password";
                }


            }
            catch (Exception ex)
            {
                lblLoginMsg.Text = "Some Problem";
            }

        }
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="contentholder" runat="Server">
    <form id="Form1" runat="server">
        <table class="bluetable" style="margin-left: auto; margin-right: auto; width: 600px;
            margin-top: 20px">
            <tr>
                <th colspan="2" style="color: #e7710b;">
                    Customer Login
                </th>
            </tr>
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
                    <div style="margin-top: 5px">
                        <a href="#TB_inline?height=200&width=400&inlineId=forgotpassword" title="forgot password"
                            class="small-link thickbox">Forgot Password ?</a>
                        <div style="display: none" id="forgotpassword">
                            <table class="bluetable" style="margin-top: 20px; width: 400px">
                                <tr>
                                    <th colspan="2">
                                        Password will be mailed to email id.
                                    </th>
                                </tr>
                                <tr>
                                    <th>
                                        Email</th>
                                    <td>
                                        <input type="text" name="forgotemail" style="width: 200px; padding: 2px 5px;" /><br />
                                        <br />
                                        <input type="button" name="forgotbtn" class="buttons" value="Send" /><span class="status"></span></td>
                                </tr>
                            </table>
                        </div>

                        <script type="text/javascript">
                          $("input[name=forgotbtn]").click(function(){
                            var btn=$("input[name=forgotbtn]");
             $.ajax({
                    'url': '../UpdateSettings.ashx',
                    'data': "email="+$("input[name=forgotemail]").val()+"&customerforgotpassword=1",
                    'dataType': 'text',
                    'type': 'POST',
                    'beforeSend':function(){
                    
                      $(btn).siblings(".status:eq(0)").html("Sending..");
                      
                      
                    },
                    'success': function(data) {
                    
                       
                        $(btn).siblings(".status:eq(0)").html("Sent.");
                         
                    }
                });
        });
                        </script>

                    </div>
                </td>
            </tr>
        </table>
    </form>
    <div style="margin-top: 30px; margin-left: auto; margin-right: auto; width: 300px;
        text-align: center; padding: 10px;border:1px solid #707070;background:white">
        <a href="../CustomerRegister.aspx" class="small-link" style="font-size:14px;text-decoration:underline">Customer Registration</a>
    </div>
</asp:Content>
