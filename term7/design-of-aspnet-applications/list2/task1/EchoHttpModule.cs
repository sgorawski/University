using System;
using System.IO;
using System.Web;

namespace ASPNET19_Z2_1
{
    public class EchoHttpModule : IHttpModule
    {
        public void Dispose()
        {
        }

        public void Init(HttpApplication context)
        {
            context.EndRequest += Context_EndRequest;
        }

        private void Context_EndRequest(object sender, EventArgs e)
        {
            var context = sender as HttpApplication;

            // URL
            context.Response.Write("URL: " + context.Request.RawUrl + Environment.NewLine + Environment.NewLine);
            
            // Headers
            context.Response.Write("Headers:" + Environment.NewLine);
            foreach (var key in context.Request.Headers.AllKeys)
            {
                context.Response.Write(key + ": " + context.Request.Headers.Get(key) + Environment.NewLine);
            }
            context.Response.Write(Environment.NewLine);

            // Method
            context.Response.Write("Method: " + context.Request.HttpMethod + Environment.NewLine + Environment.NewLine);

            // Body

            var bodyReader = new StreamReader(context.Request.InputStream);
            context.Response.Write("Body: " + bodyReader.ReadToEnd() + Environment.NewLine);

            context.Response.End();
        }
    }
}
