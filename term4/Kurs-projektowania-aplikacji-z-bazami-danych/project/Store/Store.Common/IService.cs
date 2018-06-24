using System.Collections.Generic;

namespace Store.Common
{
    public interface IService<T>
    {
        void Add(T item);
        T Find(int id);
        IEnumerable<T> FindAll();
        IEnumerable<T> GetPage(int page, int pageSize);
        void Update(T item);
        void Delete(int id);
    }
}
