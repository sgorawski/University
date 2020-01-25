using System;
using System.Collections.Generic;
using System.Linq;
using NHibernate;
using NHibernate.Cfg;
using Store.Common;

namespace Store.Infrastructure
{
    public abstract class NHibernateRepository<T> : IRepository<T> where T : class
    {
        private ISessionFactory SessionFactory { get; }
            = new Configuration().Configure().BuildSessionFactory();

        protected ISession OpenSession()
        {
            return SessionFactory.OpenSession();
        }

        public int Add(T item)
        {
            using (var s = OpenSession())
            {
                var id = (int) s.Save(item);
                s.Flush();
                return id;
            }
        }

        public T Find(int id)
        {
            using (var s = OpenSession())
            {
                return s.Get<T>(id);
            }
        }

        public IEnumerable<T> FindAll()
        {
            using (var s = OpenSession())
            {
                return s.Query<T>().ToList();
            }
        }

        public void Update(T item)
        {
            using (var s = OpenSession())
            {
                s.SaveOrUpdate(item);
                s.Flush();
            }
        }

        public bool Delete(int id)
        {
            using (var s = OpenSession())
            {
                try
                {
                    var item = s.Load<T>(id);
                    s.Delete(item);
                    s.Flush();
                    return true;
                }
                catch (ObjectNotFoundException)
                {
                    return false;
                }
            }
        }

        public IEnumerable<T> GetOrderedPage(
            int page, int pageSize, Func<T, IComparable> getProp, bool asc = true)
        {
            using (var s = OpenSession())
            {
                var query = s.QueryOver<T>().OrderBy(x => getProp(x));
                var orderedQuery = asc ? query.Asc : query.Desc;
                return orderedQuery.Skip((page - 1) * pageSize).Take(pageSize).List();
            }
        }
    }
}
