using Microsoft.VisualStudio.TestTools.UnitTesting;
using Store.ObjectMothers;

namespace Store.Domain.Tests
{
    [TestClass]
    public class ProductTests
    {
        [TestMethod]
        public void IsAvailableReturnsFalseWithQuantityZero()
        {
            var product = ProductObjectMother.CreateUnavailableProduct(1);

            var res = product.IsAvailable();

            Assert.IsFalse(res);
        }

        [TestMethod]
        public void IsAvailableReturnsTrueWithPositiveQuantity()
        {
            var product = ProductObjectMother.CreateAvailableProduct(1);

            var res = product.IsAvailable();

            Assert.IsTrue(res);
        }
    }
}
