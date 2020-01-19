using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Store.Domain.Model.Shipment;
using Store.Application.Services.ShipmentService;
using Store.ObjectMothers;

namespace Store.Application.Tests
{
    [TestClass]
    public class ShipmentServiceTests
    {
        private Mock<IShipmentRepository> ShipmentRepositoryMock { get; set; }

        private IShipmentService ShipmentService { get; set; }

        [TestInitialize]
        public void Setup()
        {
            ShipmentRepositoryMock = new Mock<IShipmentRepository>();
            ShipmentService = new ShipmentService(ShipmentRepositoryMock.Object);
        }

        [TestMethod]
        public void AddCallsAddFromRepository()
        {
            var testItem = ShipmentObjectMother.CreateShipment(1);
            ShipmentService.Add(testItem);
            ShipmentRepositoryMock.Verify(x => x.Add(testItem), Times.Once());
        }

        [TestMethod]
        public void FindCallsFindFromRepository()
        {
            ShipmentService.Find(1);
            ShipmentRepositoryMock.Verify(x => x.Find(1), Times.Once());
        }

        [TestMethod]
        public void FindAllCallsFindAllFromRepository()
        {
            ShipmentService.FindAll();
            ShipmentRepositoryMock.Verify(x => x.FindAll(), Times.Once());
        }

        [TestMethod]
        public void GetPageCallsGetOrderedPageFromRepository()
        {
            ShipmentService.GetPage(1, 1);
            ShipmentRepositoryMock.Verify(x => x.GetOrderedPage(
                1, 1, It.IsAny<Func<Shipment, IComparable>>(), true), Times.Once());
        }

        [TestMethod]
        public void UpdateCallsUpdateFromRepository()
        {
            var shipment = ShipmentObjectMother.CreateShipmentWithNoId();
            ShipmentService.Add(shipment);
            shipment.Status = ShipmentStatus.Delivered;
            ShipmentService.Update(shipment);
            ShipmentRepositoryMock.Verify(x => x.Update(shipment));
        }

        [TestMethod]
        public void DeleteCallsDeleteFromRepository()
        {
            ShipmentService.Delete(1);
            ShipmentRepositoryMock.Verify(x => x.Delete(1), Times.Once());
        }
    }
}
