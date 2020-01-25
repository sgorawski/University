namespace Store.Domain.Model.Shared
{
    public class Address
    {
        public virtual string Country { get; set; }
        public virtual string City { get; set; }
        public virtual string Detail { get; set; }
        public virtual string ZipCode { get; set; }
    }
}
