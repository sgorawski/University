<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginPage.aspx.cs" Inherits="ASPNET_Z4_2.LoginPage" %>
<html>
<head runat="server">
  <title>Login</title>
</head>
<body>
  <form id="LoginForm" runat="server">
    <h3>Login</h3>
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
      <tr>
        <td>Remember me?</td>
        <td>
          <asp:CheckBox ID="Persist" runat="server" />
        </td>
      </tr>
    </table>

    <asp:Button ID="Login" OnClick="Login_Click" Text="Log In" runat="server" />
    <p>
      <asp:Label ID="Msg" ForeColor="red" runat="server" />
    </p>
  </form>
</body>
</html>
