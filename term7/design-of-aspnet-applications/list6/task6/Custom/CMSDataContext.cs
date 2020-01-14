using System.Configuration;
using System.Data.Linq;

namespace ASPNET_Z6_6
{
    public class CMSDataContext : DataContext
    {
        public CMSDataContext() :
            base(ConfigurationManager.ConnectionStrings["LocalDB"].ConnectionString)
        { }

        public Table<Models.Site> Sites => GetTable<Models.Site>();
    }
}
