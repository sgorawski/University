using System.Security.Cryptography;
using System.Linq;

namespace ASPNET_Z5
{
    public class Auth
    {
        public const int SALT_BYTES = 32;
        public const int NUM_ITERATIONS = 10_000;
        public const int HASH_BYTES = 20;

        public static Password CreatePassword(string plaintext)
        {
            using (var kdf = new Rfc2898DeriveBytes(plaintext, SALT_BYTES, NUM_ITERATIONS))
            {
                var hash = kdf.GetBytes(HASH_BYTES);
                return new Password
                {
                    Hash = hash,
                    Salt = kdf.Salt,
                    NumIterations = kdf.IterationCount,
                };
            }
        }

        public static bool ValidatePassword(string plaintext, Password password)
        {
            using (var kdf = new Rfc2898DeriveBytes(plaintext, password.Salt, password.NumIterations))
            {
                var hash = kdf.GetBytes(password.Hash.Length);
                return hash.SequenceEqual(password.Hash);
            }
        }
    }
}
