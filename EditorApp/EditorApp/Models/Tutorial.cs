using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EditorApp.Models
{
    public class Tutorial
    {
        private int id;
        private string title;
        private string description;
        private string task;
        private string answer;

        public int Id { get => id; set => id = value; }
        public string Title { get => title; set => title = value; }
        public string Description { get => description; set => description = value; }
        public string Task { get => task; set => task = value; }
        public string Answer { get => answer; set => answer = value; }
    }
}
