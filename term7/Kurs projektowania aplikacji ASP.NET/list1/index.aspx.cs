using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace ASPNET19_Z1
{
    public partial class Index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            StreamReader sr = File.OpenText("c:\\temp\\content.txt");
            string content = sr.ReadToEnd();

            label.Text = content;

            
        }
    }
}