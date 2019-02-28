using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Store.Domain.Model.Order;
using Store.Application.Services.OrderService;
using System.Collections.Generic;
using Store.ObjectMothers;

namespace Store.Application.Tests
{
    [TestClass]
    public class OrderServiceTests
    {
        private Mock<IOrderRepository> OrderRepositoryMock { get; set; }

        private IOrderService OrderService { get; set; }

        [TestInitialize]
        public void Setup()
        {
            OrderRepositoryMock = new Mock<IOrderRepository>();
            OrderService = new OrderService(OrderRepositoryMock.Object);
        }

        [TestMethod]
        public void AddCallsAddFromRepository()
        {
            var testItem = OrderObjectMother.CreateOrderWithItems(1);
            OrderService.Add(testItem);
            OrderRepositoryMock.Verify(x => x.Add(testItem), Times.Once());
        }

        [TestMethod]
        public void FindCallsFindFromRepository()
        {
            OrderService.Find(1);
            OrderRepositoryMock.Verify(x => x.Find(1), Times.Once());
        }

        [TestMethod]
        public void FindAllCallsFindAllFromRepository()
        {
            OrderService.FindAll();
            OrderRepositoryMock.Verify(x => x.FindAll(), Times.Once());
        }

        [TestMethod]
        public void GetPageCallsGetOrderedPageFromRepository()
        {
            OrderService.GetPage(1, 1);
            OrderRepositoryMock.Verify(x => x.GetOrderedPage(
                1, 1, It.IsAny<Func<Order, IComparable>>(), true), Times.Once());
        }

        [TestMethod]
        public void UpdateCallsUpdateFromRepository()
        {
            var order = OrderObjectMother.CreateEmptyOrderWithNoId();
            OrderService.Add(order);
            order.CustomerId = 2137;
            OrderService.Update(order);
            OrderRepositoryMock.Verify(x => x.Update(order));
        }

        [TestMethod]
        public void DeleteCallsDeleteFromRepository()
        {
            OrderService.Delete(1);
            OrderRepositoryMock.Verify(x => x.Delete(1), Times.Once());
        }

        [TestMethod]
        public void FindAllOfCustomerCallsFinAllOfCustomerFromRepository()
        {
            OrderService.FindAllOfCustomer(1);
            OrderRepositoryMock.Verify(x => x.FindAllOfCustomer(1), Times.Once());
        }
    }
}
