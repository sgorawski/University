using System;
using System.Collections.Generic;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Store.Domain.Model.Product;
using Store.Application.Services.ProductService;
using Store.ObjectMothers;

namespace Store.Application.Tests
{
    [TestClass]
    public class ProductServiceTests
    {
        private Mock<IProductRepository> ProductRepositoryMock { get; set; }

        private IProductService ProductService { get; set; }

        [TestInitialize]
        public void Setup()
        {
            ProductRepositoryMock = new Mock<IProductRepository>();
            ProductService = new ProductService(ProductRepositoryMock.Object);
        }

        [TestMethod]
        public void AddCallsAddFromRepository()
        {
            var testItem = ProductObjectMother.CreateAvailableProduct(1);
            ProductService.Add(testItem);
            ProductRepositoryMock.Verify(x => x.Add(testItem), Times.Once());
        }

        [TestMethod]
        public void FindCallsFindFromRepository()
        {
            ProductService.Find(1);
            ProductRepositoryMock.Verify(x => x.Find(1), Times.Once());
        }

        [TestMethod]
        public void FindAllCallsFindAllFromRepository()
        {
            ProductService.FindAll();
            ProductRepositoryMock.Verify(x => x.FindAll(), Times.Once());
        }

        [TestMethod]
        public void GetPageCallsGetOrderedPageFromRepository()
        {
            ProductService.GetPage(1, 1);
            ProductRepositoryMock.Verify(x => x.GetOrderedPage(
                1, 1, It.IsAny<Func<Product, IComparable>>(), true), Times.Once());
        }

        [TestMethod]
        public void UpdateCallsUpdateFromRepository()
        {
            var product = ProductObjectMother.CreateProductWithNoId();
            ProductService.Add(product);
            product.Name = "New name";
            ProductService.Update(product);
            ProductRepositoryMock.Verify(x => x.Update(product));
        }

        [TestMethod]
        public void DeleteCallsDeleteFromRepository()
        {
            ProductService.Delete(1);
            ProductRepositoryMock.Verify(x => x.Delete(1), Times.Once());
        }

        [TestMethod]
        public void GetPageOrderedByPriceAscCallsGetOrderedPageFromRepository()
        {
            ProductService.GetPageOrderedByPriceAsc(1, 1);
            ProductRepositoryMock.Verify(x => x.GetOrderedPage(
                1, 1, It.IsAny<Func<Product, IComparable>>(), true), Times.Once());
        }

        [TestMethod]
        public void GetPageOrderedByPriceDescCallsGetOrderedPageFromRepository()
        {
            ProductService.GetPageOrderedByPriceDesc(1, 1);
            ProductRepositoryMock.Verify(x => x.GetOrderedPage(
                1, 1, It.IsAny<Func<Product, IComparable>>(), false), Times.Once());
        }
    }
}
