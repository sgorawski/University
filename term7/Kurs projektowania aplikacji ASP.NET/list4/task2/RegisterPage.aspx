<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegisterPage.aspx.cs" Inherits="ASPNET_Z4_2.RegisterPage" %>
<html>
<head runat="server">
  <title>Register</title>
</head>
<body>
  <form id="LoginForm" runat="server">
    <h3>Register</h3>
    <table>
      <tr>
        <td>Username:</td>
        <td>
          <asp:TextBox ID="Username" runat="server" />
        </td>
        <td>
          <asp:RequiredFieldValidator ID="UserNameRequiredValidator" 
            ControlToValidate="Username"
            ErrorMessage="Cannot be empty." 
            runat="server"
          />
        </td>
      </tr>
      <tr>
        <td>Password:</td>
        <td>
          <asp:TextBox ID="Password" TextMode="Password" runat="server" />
        </td>
        <td>
          <asp:RequiredFieldValidator ID="PasswordRequiredValidator" 
            ControlToValidate="Password"
            ErrorMessage="Cannot be empty." 
            runat="server"
          />
        </td>
      </tr>
    </table>

    <asp:Button ID="Register" OnClick="Register_Click" Text="Register" runat="server" />
    <p>
      <asp:Label ID="Msg" ForeColor="red" runat="server" />
    </p>
  </form>
</body>
</html>
