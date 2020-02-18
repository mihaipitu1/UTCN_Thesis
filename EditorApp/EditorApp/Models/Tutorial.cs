using Newtonsoft.Json;
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

        [JsonProperty("id")]
        public int Id { get => id; set => id = value; }
        [JsonProperty("title")]
        public string Title { get => title; set => title = value; }
        [JsonProperty("description")]
        public string Description { get => description; set => description = value; }
        [JsonProperty("task")]
        public string Task { get => task; set => task = value; }
        [JsonProperty("answer")]
        public string Answer { get => answer; set => answer = value; }
    }
}
