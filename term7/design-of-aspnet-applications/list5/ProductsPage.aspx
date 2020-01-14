<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProductsPage.aspx.cs" Inherits="ASPNET_Z5.ProductsPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Products</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <p>
                <asp:LoginName runat="server" />
                <asp:LoginStatus ID="LoginStatus" runat="server" />
            </p>
            <asp:ListView
                ID="ProductsListView"
                runat="server"
                DataSourceID="ProductsDataSource"
                ItemType="ASPNET_Z5.Product"
                ItemPlaceholderID="ProductsListPlaceholder"
                OnItemCommand="ProductsListView_ItemCommand"
            >
                <LayoutTemplate>
                    <table>
                        <thead>
                            <tr>
                                <th>
                                    <asp:LinkButton runat="server" Text="Name" CommandName="Sort" CommandArgument="Name" />
                                </th>
                                <th>
                                    <asp:LinkButton runat="server" Text="Description" CommandName="Sort" CommandArgument="Description" />
                                </th>
                                <th>
                                    <asp:LinkButton runat="server" Text="Price" CommandName="Sort" CommandArgument="Price" />
                                </th>
                                <th>
                                    <asp:LinkButton runat="server" Text="ImageURL" CommandName="Sort" CommandArgument="ImageURL" />
                                </th>
                                <asp:LoginView runat="server">
                                    <LoggedInTemplate>
                                        <th>Admin</th>
                                    </LoggedInTemplate>
                                </asp:LoginView>
                                <th>Add to cart</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:PlaceHolder ID="ProductsListPlaceholder" runat="server" />
                            <tr>
                                <td colspan="5">
                                    <asp:DataPager ID="ProductsPager" runat="server" PagedControlID="ProductsListView" PageSize="10">
                                        <Fields>
                                            <asp:NumericPagerField ButtonCount="8" ButtonType="Link" />
                                        </Fields>
                                    </asp:DataPager>
                                </td>
                            </tr>
                            <asp:LoginView runat="server">
                                <LoggedInTemplate>
                                    <tr>
                                        <td colspan="5">
                                            <asp:LinkButton
                                                ID="AddProductButton"
                                                runat="server"
                                                Text="Add new item"
                                                CommandName="ShowInsertView"
                                            />
                                        </td>
                                    </tr>
                                </LoggedInTemplate>
                            </asp:LoginView>
                        </tbody>
                    </table>
                </LayoutTemplate>
                <ItemTemplate>
                    <tr>
                        <td><%# Item.Name %></td>
                        <td><%# Item.Description %></td>
                        <td><%# Item.Price %></td>
                        <td><%# Item.ImageURL %></td>
                        <% if (User.Identity.IsAuthenticated) { %>
                                <td>
                                    <asp:LinkButton Text="Edit" runat="server" CommandName="Edit" CommandArgument="<%#Item.ID %>" />
                                    <asp:LinkButton Text="Delete" runat="server" CommandName="Delete" CommandArgument="<%#Item.ID %>" />
                                </td>
                        <% } %>
                        <td>
                            <asp:LinkButton Text="Add to cart" runat="server" CommandName="AddToCart" CommandArgument="<%# Item.ID %>" />
                        </td>
                    </tr>
                </ItemTemplate>
                <InsertItemTemplate>
                    <tr>
                        <td colspan="5">
                            <table>
                                <tr>
                                    <td>
                                        <asp:Label ID="NameInsertLabel" runat="server" Text="Name" AssociatedControlID="NameInsert" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="NameInsert" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="DescriptionInsertLabel" runat="server" Text="Description" AssociatedControlID="DescriptionInsert" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="DescriptionInsert" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="PriceInsertLabel" runat="server" Text="Price" AssociatedControlID="PriceInsert" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="PriceInsert" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="ImageURLInsertLabel" runat="server" Text="Image URL" AssociatedControlID="ImageURLInsert" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="ImageURLInsert" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <asp:LinkButton ID="InsertItemButton" runat="server" Text="Accept" CommandName="Insert" />
                                        <asp:LinkButton ID="CancelInsertButton" runat="server" Text="Cancel" CommandName="HideInsertView" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </InsertItemTemplate>
                <EditItemTemplate>
                    <tr>
                        <td colspan="5">
                            <table>
                                <tr>
                                    <asp:HiddenField ID="IDUpdate" runat="server" Value="<%# Item.ID %>" />
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="NameUpdateLabel" runat="server" Text="Name" AssociatedControlID="NameUpdate" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="NameUpdate" runat="server" Text="<%# Item.Name %>" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="DescriptionUpdateLabel" runat="server" Text="Description" AssociatedControlID="DescriptionUpdate" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="DescriptionUpdate" runat="server" Text="<%# Item.Description %>" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="PriceUpdateLabel" runat="server" Text="Price" AssociatedControlID="PriceUpdate" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="PriceUpdate" runat="server" Text="<%# Item.Price %>" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="ImageURLUpdateLabel" runat="server" Text="Image URL" AssociatedControlID="ImageURLUpdate" />
                                    </td>
                                    <td>
                                        <asp:TextBox ID="ImageURLUpdate" runat="server" Text="<%# Item.ImageURL %>" />
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <asp:LinkButton ID="UpdateItemButton" runat="server" Text="Accept" CommandName="Update" />
                                        <asp:LinkButton ID="CancelUpdateButton" runat="server" Text="Cancel" CommandName="Cancel" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </EditItemTemplate>
            </asp:ListView>

            <asp:ObjectDataSource
                ID="ProductsDataSource"
                runat="server"
                TypeName="ASPNET_Z5.Product_DataProvider"
                SelectMethod="GetAll"
                EnablePaging="True"
                MaximumRowsParameterName="limit"
                StartRowIndexParameterName="offset"
                SortParameterName="orderBy"
                SelectCountMethod="GetNumber"
                InsertMethod="Add"
                OnInserting="ProductsDataSource_Inserting"
                OnInserted="ProductsDataSource_Inserted"
                UpdateMethod="Update"
                OnUpdating="ProductsDataSource_Updating"
                OnUpdated="ProductsDataSource_Updated"
                DeleteMethod="Delete"
                OnDeleting="ProductsDataSource_Deleting"
                OnDeleted="ProductsDataSource_Deleted"
            />

            <asp:LinkButton ID="CartLink" runat="server" Text="View my cart" PostBackUrl="~/ShoppingCartPage.aspx" />
        </div>
    </form>
</body>
</html>
