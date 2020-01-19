using Store.Common;
using Store.Domain.Model.Shared;

namespace Store.Domain.Model.Customer
{
    public class Customer : IEntity
    {
        public virtual int Id { get; set; }
        public virtual string Name { get; set; }
        public virtual string Email { get; set; }
        public virtual Address Address { get; set; }
    }
}
