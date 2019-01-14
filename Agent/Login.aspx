<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/CharterTemplate.master"
    CodeFile="Login.aspx.cs" Inherits="Agent_Login" %>

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

                Agent a = AgentDAO.GetAgentByEmailPassword(userName.Text, txtPwd.Text);
                if (a != null)
                {
                    Authticket = new FormsAuthenticationTicket(
                                                        1,
                                                        a.AgentID.ToString(),
                                                        DateTime.Now,
                                                        DateTime.Now.AddMinutes(180),
                                                        false,
                                                        "Agent",
                                                        FormsAuthentication.FormsCookiePath);

                    hash = FormsAuthentication.Encrypt(Authticket);

                    Authcookie = new HttpCookie(FormsAuthentication.FormsCookieName, hash);

                    if (Authticket.IsPersistent) Authcookie.Expires = Authticket.Expiration;

                    Response.Cookies.Add(Authcookie);

                    returnUrl = Request.QueryString["ReturnUrl"];
                    Session["AgentID"] = a.AgentID;
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
        <table class="bluetable" style="margin-left: 10px; margin-right: 20px; width: 400px;
            margin-top: 30px;float:left">
            <tr>
                <th colspan="2" style="color: #e7710b;">
                    Agent Login
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
                    <asp:Button ID="btnLogin" Text="Login" OnClick="Login_Click" runat="Server" CssClass="buttons"
                        Width="100px" />
                    <asp:Label ID="lblLoginMsg" CssClass="error" runat="server" />
                    <div style="margin-top: 5px">
                        <a href="#TB_inline?height=200&width=400&inlineId=forgotpassword" title="forgot password"
                            class="small-link thickbox">Forgot Password ?</a>
                        <div style="display: none" id="forgotpassword">
                            <table class="bluetable" style="margin-top:20px;width:400px">
                                <tr>
                                    <th colspan="2">
                                        Password will be mailed to email id.
                                    </th>
                                </tr>
                                <tr>
                                    <th>
                                        Email</th>
                                    <td>
                                        <input type="text" name="forgotemail" style="width:200px;padding:2px 5px;" /><br /><br /><input type="button" name="forgotbtn" class="buttons" value="Send" /><span class="status"></span></td>
                                </tr>
                            </table>
                        </div>

                        <script type="text/javascript">
                          $("input[name=forgotbtn]").click(function(){
                            var btn=$("input[name=forgotbtn]");
             $.ajax({
                    'url': '../UpdateSettings.ashx',
                    'data': "email="+$("input[name=forgotemail]").val()+"&agentforgotpassword=1",
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
    <div style="width: 400px;margin-top: 30px;
        background: white; border: 1px solid #e7710b; padding: 10px; font-size: 11px;
        text-align: center;float:left">
        <div style="font-size: 14px; margin-bottom: 10px; font-weight: bold">
            New to our <span style="color: #e7710b">Global Distribution System ?</span></div>
        <div class="airnetz-lists" style="margin-top: 15px;">
            <ul style="width: 300px; margin-left: auto; margin-right: auto; text-align: left">
                <li style="margin: 10px">Embed link in your website</li>
                <li style="margin: 10px">Manage Customers</li>
                <li style="margin: 10px">Manage Charter Requests</li>
            </ul>
        </div>
        <div style="text-align: center; margin-top: 20px;">
            <a href="../AgentRegister.aspx" class="redlinkbutton">Agent SIGN UP</a>
        </div>
    </div>
    <div class="clear"></div>
</asp:Content>
