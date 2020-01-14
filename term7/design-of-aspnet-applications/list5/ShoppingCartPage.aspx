<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ShoppingCartPage.aspx.cs" Inherits="ASPNET_Z5.ShoppingCartPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Shopping Cart</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h1>My Shopping Cart</h1>
            <table>
                <thead>
                    <tr>
                        <th>Name</th>
                        <th>Description</th>
                        <th>Price</th>
                        <th>Image</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater
                        ID="ProductsRepeater"
                        runat="server"
                        DataSourceID="ShoppingCartDataSource"
                        ItemType="ASPNET_Z5.Product"
                    >
                        <ItemTemplate>
                            <tr>
                                <td><%# Item.Name %></td>
                                <td><%# Item.Description %></td>
                                <td><%# Item.Price %></td>
                                <td><%# Item.ImageURL %></td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>

            <asp:ObjectDataSource
                ID="ShoppingCartDataSource"
                runat="server"
                TypeName="ASPNET_Z5.ShoppingCart"
                SelectMethod="GetAllProducts"
            />

            <asp:LinkButton ID="ProductsLink" runat="server" Text="Back to products" PostBackUrl="~/ProductsPage.aspx" />
        </div>
    </form>
</body>
</html>
