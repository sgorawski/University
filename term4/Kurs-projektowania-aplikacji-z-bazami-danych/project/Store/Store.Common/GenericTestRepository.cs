using System;
using System.Collections.Generic;
using System.Linq;

namespace Store.Common
{
    public abstract class GenericTestRepository<T> : IRepository<T> where T : IEntity
    {
        private ICollection<T> Items { get; }

        protected GenericTestRepository(ICollection<T> items)
        {
            Items = items;
        }

        public int Add(T item)
        {
            Items.Add(item);

            return item.Id;
        }

        public T Find(int id)
        {
            return Items.FirstOrDefault(i => i.Id == id);
        }

        public IEnumerable<T> FindAll()
        {
            return Items;
        }

        public void Update(T item)
        {
            Delete(item.Id);
            Add(item);
        }

        public bool Delete(int id)
        {
            try
            {
                var toRemove = Items.First(i => i.Id == id);
                Items.Remove(toRemove);
                return true;
            }
            catch (InvalidOperationException)
            {
                return false;
            }
        }

        public IEnumerable<T> GetOrderedPage(
            int page, int pageSize, Func<T, IComparable> getProp, bool asc = true)
        {
            var orderedAll = asc ? Items.OrderBy(getProp) : Items.OrderByDescending(getProp);
            return orderedAll.Skip((page - 1) * pageSize).Take(pageSize);
        }
    }
}
