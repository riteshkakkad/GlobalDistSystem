<%@ Page Language="C#" Async="true" AutoEventWireup="true" MasterPageFile="~/CharterTemplate.master"
    CodeFile="AgentRegister.aspx.cs" Inherits="AgentRegister" %>
<asp:Content runat="server" ContentPlaceHolderID="scriptholder">

</asp:Content>
<asp:Content ContentPlaceHolderID="contentholder" runat="server">
    <div id="Status" style="border: solid 1px #e7710b; color: #e7710b;background:white; padding: 5px;
        margin-bottom: 20px; text-align: center" runat="server">
    </div>
    <form id="AgentForm" runat="server">
        <table class="bluetable">
            <tr>
                <th colspan="2" style="color: #e7710b;">
                    Agent Registration
                </th>
            </tr>
            <tr>
                <td valign="top" style="width: 450px;">
                    <table class="bluetable">
                        <tr>
                            <th>
                                Agent Name
                            </th>
                            <td>
                                <input id="AgentName" name="AgentName" type="text" runat="server" />
                                <div>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Agent Name cannot be blank."
                                        CssClass="error" ControlToValidate="AgentName" Display="Dynamic"></asp:RequiredFieldValidator></div>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Agency Name
                            </th>
                            <td>
                                <input id="AgencyName" name="AgencyName" runat="server" />
                                <div>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Agency Name cannot be blank."
                                        CssClass="error" Display="Dynamic" ControlToValidate="AgencyName"></asp:RequiredFieldValidator>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Country
                            </th>
                            <td>
                                <select id="country" runat="server">
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Email
                            </th>
                            <td>
                                <input id="Email" name="Email" type="text" runat="server" />
                                <div>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="Email cannot be blank."
                                        CssClass="error" Display="Dynamic" ControlToValidate="Email"></asp:RequiredFieldValidator>
                                </div>
                                <div>
                                    <asp:RegularExpressionValidator ID="rfvUserEmailValidate" runat="server" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                        CssClass="error" ControlToValidate="Email" Display="Dynamic" ErrorMessage="Invalid Email Format"></asp:RegularExpressionValidator></div>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Password
                            </th>
                            <td>
                                <input id="Password" type="password" name="Password" runat="server" />
                                <div>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ErrorMessage="Password cannot be blank."
                                        CssClass="error" Display="Dynamic" ControlToValidate="Password"></asp:RequiredFieldValidator></div>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Retype Password
                            </th>
                            <td>
                                <input id="ConfirmPassword" type="password" name="ConfirmPassword" runat="server" />
                                <div>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" ErrorMessage="Retype your password."
                                        CssClass="error" Display="Dynamic" ControlToValidate="ConfirmPassword"></asp:RequiredFieldValidator>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Alternate Email(optional)
                            </th>
                            <td>
                                <input id="AlternateEmail" name="AlternateEmail" type="text" runat="server" />
                                <div>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                        CssClass="error" ControlToValidate="AlternateEmail" ErrorMessage="Invalid Email Format"
                                        Display="Dynamic"></asp:RegularExpressionValidator></div>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Contact No.
                            </th>
                            <td>
                                <input id="ContactNo" name="ContactNo" type="text" runat="server" />
                                <div>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ErrorMessage="Contact No cannot be blank."
                                        CssClass="error" ControlToValidate="ContactNo" Display="Dynamic"></asp:RequiredFieldValidator></div>
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Alternate Contact No.(optional)
                            </th>
                            <td>
                                <input id="AlternateContactNo" name="AlternateContactNo" type="text" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Fax(optional)
                            </th>
                            <td>
                                <input id="Fax" name="Fax" type="text" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <th>
                                Billing Address
                            </th>
                            <td>
                                <textarea id="BillingAddress" name="BillingAddress" cols="20" rows="2" runat="server"></textarea>
                                <div>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ErrorMessage="Billing Address cannot be blank."
                                        CssClass="error" Display="Dynamic" ControlToValidate="BillingAddress"></asp:RequiredFieldValidator></div>
                            </td>
                        </tr>
                    </table>
                </td>
                <td style="text-align: center">
                    <iframe src="Webpartneragreement_bookjetz.htm" style="border: solid 1px #707070;"
                        allowtransparency="true" width="400" height="300"></iframe>
                    <br />
                    <span style="font-size: 11px;">* By registering , you are accepting the Terms and Conditions
                        decided by Airnetz Aviation Pvt. Ltd.</span><br />
                    <br />
                    <br />
                    <div>
                        <asp:CompareValidator ID="CompareValidator1" runat="server" ErrorMessage="Password mismatch."
                            ControlToCompare="Password" CssClass="error" Display="Dynamic" ControlToValidate="ConfirmPassword"
                            Operator="Equal"></asp:CompareValidator></div>
                    <asp:Button ID="Button1" CssClass="buttons" Width="150px" runat="server" Text="Register"
                        PostBackUrl="~/AgentRegister.aspx"></asp:Button>
                </td>
            </tr>
        </table>
    </form>
</asp:Content>
