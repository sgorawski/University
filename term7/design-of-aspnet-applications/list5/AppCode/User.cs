using System;
using System.Data.Linq;
using System.Data.Linq.Mapping;

namespace ASPNET_Z5
{
    [Table(Name = "Users")]
    public class User
    {
        [Column(IsPrimaryKey = true)]
        public Guid ID { get; set; } = Guid.NewGuid();
        
        [Column]
        public string Name { get; set; }

        [Column]
        public string Email { get; set; }

        private EntityRef<Password> _password;
        [Association( Storage = "_password", OtherKey = "UserID")]
        public Password Password
        {
            get => _password.Entity;
            set {
                value.UserID = ID;
                _password.Entity = value;
            }
        }
    }
}