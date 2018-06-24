using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Moq;
using Store.Domain.Model.Customer;
using Store.Application.Services.CustomerService;
using Store.ObjectMothers;

namespace Store.Application.Tests
{
    [TestClass]
    public class CustomerServiceTests
    {
        private Mock<ICustomerRepository> CustomerRepositoryMock { get; set; }

        private ICustomerService CustomerService { get; set; }

        [TestInitialize]
        public void Setup()
        {
            CustomerRepositoryMock = new Mock<ICustomerRepository>();
            CustomerService = new CustomerService(CustomerRepositoryMock.Object);
        }

        [TestMethod]
        public void AddCallsAddFromRepository()
        {
            var testItem = CustomerObjectMother.CreateCustomer(1);
            CustomerService.Add(testItem);
            CustomerRepositoryMock.Verify(x => x.Add(testItem), Times.Once());
        }

        [TestMethod]
        public void FindCallsFindFromRepository()
        {
            CustomerService.Find(1);
            CustomerRepositoryMock.Verify(x => x.Find(1), Times.Once());
        }

        [TestMethod]
        public void FindAllCallsFindAllFromRepository()
        {
            CustomerService.FindAll();
            CustomerRepositoryMock.Verify(x => x.FindAll(), Times.Once());
        }

        [TestMethod]
        public void GetPageCallsGetOrderedPageFromRepository()
        {
            CustomerService.GetPage(1, 1);
            CustomerRepositoryMock.Verify(x => x.GetOrderedPage(
                1, 1, It.IsAny<Func<Customer, IComparable>>(), true), Times.Once());
        }

        [TestMethod]
        public void UpdateCallsUpdateFromRepository()
        {
            var customer = CustomerObjectMother.CreateCustomerWithNoId();
            CustomerService.Add(customer);
            customer.Name = "New name";
            CustomerService.Update(customer);
            CustomerRepositoryMock.Verify(x => x.Update(customer));
        }

        [TestMethod]
        public void DeleteCallsDeleteFromRepository()
        {
            CustomerService.Delete(1);
            CustomerRepositoryMock.Verify(x => x.Delete(1), Times.Once());
        }
    }
}
