using System.Configuration;
using System.Data.Linq;

namespace ASPNET_Z7
{
    public class StoreDataContext : DataContext
    {
        public StoreDataContext() :
            base(ConfigurationManager.ConnectionStrings["LocalDB"].ConnectionString)
        { }

        public Table<Models.Product> Products => GetTable<Models.Product>();

        public Table<Models.User> Users => GetTable<Models.User>();
    }
}