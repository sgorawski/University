using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ASPNET_Z5
{
    public partial class ProductsPage : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
                ProductsListView.DataBind();
        }

        protected void ProductsListView_ItemCommand(object sender, ListViewCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "ShowInsertView":
                    ProductsListView.InsertItemPosition = InsertItemPosition.LastItem;
                    ProductsListView.DataBind();
                    ProductsListView.InsertItem.DataBind();
                    break;

                case "HideInsertView":
                    ProductsListView.InsertItemPosition = InsertItemPosition.None;
                    break;

                case "AddToCart":
                    var cart = new ShoppingCart();
                    cart.AddProduct(Convert.ToInt32(e.CommandArgument));
                    break;

                case "Delete":
                    ProductsDataSource.DeleteParameters.Add("ID", e.CommandArgument.ToString());
                    break;
            }
        }

        protected void ProductsDataSource_Inserting(object sender, ObjectDataSourceMethodEventArgs e)
        {
            Product product = new Product
            {
                Name = ((TextBox)ProductsListView.InsertItem.FindControl("NameInsert")).Text,
                Description = ((TextBox)ProductsListView.InsertItem.FindControl("DescriptionInsert")).Text,
                Price = Convert.ToDecimal(((TextBox)ProductsListView.InsertItem.FindControl("PriceInsert")).Text),
                ImageURL = ((TextBox)ProductsListView.InsertItem.FindControl("ImageURLInsert")).Text
            };

            e.InputParameters.Clear();
            e.InputParameters.Add("product", product);
        }

        protected void ProductsDataSource_Inserted(object sender, ObjectDataSourceStatusEventArgs e)
        {
            ProductsListView.InsertItemPosition = InsertItemPosition.None;
            ProductsListView.DataBind();
        }

        protected void ProductsDataSource_Updating(object sender, ObjectDataSourceMethodEventArgs e)
        {
            var id = Convert.ToInt32(((HiddenField)ProductsListView.EditItem.FindControl("IDUpdate")).Value);
            Product product = new Product
            {
                ID = id,
                Name = ((TextBox)ProductsListView.EditItem.FindControl("NameUpdate")).Text,
                Description = ((TextBox)ProductsListView.EditItem.FindControl("DescriptionUpdate")).Text,
                Price = Convert.ToDecimal(((TextBox)ProductsListView.EditItem.FindControl("PriceUpdate")).Text),
                ImageURL = ((TextBox)ProductsListView.EditItem.FindControl("ImageURLUpdate")).Text
            };
            e.InputParameters.Clear();
            e.InputParameters.Add("product", product);
        }

        protected void ProductsDataSource_Updated(object sender, ObjectDataSourceStatusEventArgs e)
        {
            ProductsListView.DataBind();
        }

        protected void ProductsDataSource_Deleting(object sender, ObjectDataSourceMethodEventArgs e)
        {
            var id = Convert.ToInt32(e.InputParameters["ID"]);
            e.InputParameters.Clear();
            e.InputParameters.Add("id", id);
        }

        protected void ProductsDataSource_Deleted(object sender, ObjectDataSourceStatusEventArgs e)
        {
            ProductsListView.DataBind();
        }
    }
}