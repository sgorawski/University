namespace Store.Domain.Model.Order
{
    public class OrderItem
    {
        public virtual int ProductId { get; set; }
        public virtual int ProductPrice { get; set; }
        public virtual int ProductQuantity { get; set; }
    }
}