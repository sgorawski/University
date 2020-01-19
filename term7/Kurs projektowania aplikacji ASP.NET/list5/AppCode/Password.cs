using System;
using System.Data.Linq.Mapping;

namespace ASPNET_Z5
{
    [Table(Name = "Passwords")]
    public class Password
    {
        [Column(IsPrimaryKey = true)]
        public Guid ID { get; set; } = Guid.NewGuid();

        [Column]
        public Guid UserID { get; set; }

        [Column]
        public byte[] Hash { get; set; }

        [Column]
        public byte[] Salt { get; set; }

        [Column]
        public int NumIterations { get; set; }

        [Column]
        public DateTime CreatedAt { get; set; } = DateTime.Now;
     }
}