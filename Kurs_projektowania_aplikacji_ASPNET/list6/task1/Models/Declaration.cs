using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace ASPNET_Z6.Models
{
    public class Declaration
    {
        public const int TOTAL_NUM_TASKS = 10;

        [Required]
        [Display(Name = "Name")]
        public string StudentName { get; set; }

        [Required]
        [DisplayFormat(DataFormatString = "{0:d}", ApplyFormatInEditMode = true)]
        public DateTime Date { get; set; } = DateTime.Now;

        [Required]
        [Display(Name = "Class")]
        public string ClassName { get; set; }

        [Required]
        [Display(Name = "Task set")]
        public string TaskSet { get; set; }

        public IList<int> TasksPoints { get; set; } = new int[TOTAL_NUM_TASKS].ToList();
    }
}