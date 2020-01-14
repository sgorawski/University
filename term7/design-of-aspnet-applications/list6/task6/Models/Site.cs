using System;
using System.Linq;
using System.Data.Linq;
using System.Data.Linq.Mapping;
using System.Collections.Generic;

namespace ASPNET_Z6_6.Models
{
    [Table(Name = "Sites")]
    public class Site
    {
        [Column(IsPrimaryKey = true)]
        public Guid ID { get; set; } = Guid.NewGuid();

        [Column]
        public Guid? SuperSiteID { get; set; }

        [Column]
        public string Name { get; set; }

        [Column]
        public string ContentHTML { get; set; }


        private EntitySet<Site> _subSites;
        
        [Association(Storage = "_subSites", OtherKey = "SuperSiteID")]
        public IEnumerable<Site> SubSites
        {
            get => _subSites;
            set => _subSites = (EntitySet<Site>) value;
        }

        public void AddSubSite(Site subSite)
        {
            subSite.SuperSiteID = ID;
            _subSites.Add(subSite);
        }

        public IEnumerable<Site> GetAllSubSites() => SubSites;

        public Site GetSub(string name) => SubSites.FirstOrDefault(s => s.Name == name);
    }
}
