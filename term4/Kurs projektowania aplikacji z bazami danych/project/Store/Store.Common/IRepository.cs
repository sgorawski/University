using System;
using System.Collections.Generic;

namespace Store.Common
{
    public interface IRepository<T>
    {
        int Add(T item);
        T Find(int id);
        IEnumerable<T> FindAll();
        void Update(T item);
        bool Delete(int id);
        IEnumerable<T> GetOrderedPage(
            int page, int pageSize, Func<T, IComparable> getProp, bool asc = true);
    }
}
