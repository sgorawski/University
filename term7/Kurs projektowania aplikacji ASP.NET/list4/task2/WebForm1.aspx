<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="ASPNET_Z4_2.WebForm1" %>
<html>
<head>
  <title>WebForm1</title>
</head>
<body>
  <asp:Label ID="Welcome" runat="server" />
  <form id="SignoutForm" runat="server">
    <asp:Button
      ID="Signout"
      OnClick="Signout_Click"
      Text="Sign Out"
      runat="server"
    />
  </form>
</body>
</html>