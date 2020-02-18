using EditorApp.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using System.IO;

namespace EditorApp.Utilities
{
    public class TutorialUtility
    {
        private List<Tutorial> tutorials;
        private static readonly string storageFile = "../../Storage/tutorials.json";

        public TutorialUtility()
        {
            tutorials = new List<Tutorial>();
            LoadTutorials();
        }

        private void LoadTutorials()
        {
            Stream fileStream;
            
            using(fileStream  = File.Open(storageFile,FileMode.Open))
            {
                using(StreamReader sr = new StreamReader(fileStream))
                {
                    string infoRead = sr.ReadToEnd();
                    tutorials =  JsonConvert.DeserializeObject<List<Tutorial>>(infoRead);
                    Console.WriteLine(tutorials.Count);
                }
            }
        }
        
        public List<Tutorial> GetTutorials()
        {
            return tutorials;
        }
    }
}
