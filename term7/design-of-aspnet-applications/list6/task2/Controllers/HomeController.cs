using System.IO;
using System.Web;
using System.Web.Mvc;
using System.Xml;

namespace ASPNET_Z6_2.Controllers
{
    public class HomeController : Controller
    {
        // GET: Home
        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Index(HttpPostedFileBase File)
        {
            var size = File.ContentLength;
            var checksum = ComputeChecksum(File.InputStream);
            var xml = BuildXMLResponse(File.FileName, size, checksum);
            return new FileStreamResult(xml, contentType: "text/xml") { FileDownloadName = "meta.xml" };
        }

        private static int ComputeChecksum(Stream fileContents)
        {
            using (var sr = new StreamReader(fileContents))
            {
                // Seems like a great use case for Linq (reduce),
                // not sure how to use it with StreamReader though.
                int checksum = 0;
                while (!sr.EndOfStream)
                {
                    checksum += sr.Read();
                    checksum %= 0xFFFF;
                }
                return checksum;
            }
        }

        private static Stream BuildXMLResponse(string fileName, int fileSizeBytes, int checksum)
        {
            var result = new MemoryStream();
            using (var xml = XmlWriter.Create(result))
            {
                xml.WriteStartElement("opis");

                xml.WriteStartElement("nazwa");
                xml.WriteString(fileName);
                xml.WriteEndElement();

                xml.WriteStartElement("rozmiar");
                xml.WriteString(fileSizeBytes.ToString());
                xml.WriteEndElement();

                xml.WriteStartElement("sygnatura");
                xml.WriteString(checksum.ToString());
                xml.WriteEndElement();

                xml.WriteEndElement();
                xml.Flush();
            }

            result.Position = 0; // For reading response
            return result;
        }
    }
}