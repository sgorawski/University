using System.Data.Linq.Mapping;

namespace ASPNET_Z5
{
    [Table(Name = "Products")]
    public class Product
    {
        [Column(IsPrimaryKey = true, IsDbGenerated = true)]
        public int ID { get; set; }
        [Column]
        public string Name { get; set; }
        [Column]
        public string Description { get; set; }
        [Column]
        public decimal Price { get; set; }
        [Column]
        public string ImageURL { get; set; }
    }
}