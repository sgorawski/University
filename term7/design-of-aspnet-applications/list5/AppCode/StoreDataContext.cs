using System.Configuration;
using System.Data.Linq;

namespace ASPNET_Z5
{
    public class StoreDataContext : DataContext
    {
        public StoreDataContext() :
            base(ConfigurationManager.ConnectionStrings["LocalDB"].ConnectionString) { }

        public Table<Product> Products { get => GetTable<Product>(); }

        public Table<User> Users { get => GetTable<User>(); }
    }
}