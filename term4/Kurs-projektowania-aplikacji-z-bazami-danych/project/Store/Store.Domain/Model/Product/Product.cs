using Store.Common;

namespace Store.Domain.Model.Product
{
    public class Product : IEntity
    {
        public virtual int Id { get; set; }
        public virtual string Name { get; set; }
        public virtual string Description { get; set; }
        public virtual string ImageUrl { get; set; }
        public virtual int Price { get; set; }
        public virtual int Quantity { get; set; }

        public virtual bool IsAvailable()
        {
            return Quantity > 0;
        }
    }
}
