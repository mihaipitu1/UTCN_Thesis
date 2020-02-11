using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace EditorApp.Utilities
{
    public class FileUtility
    {
        public string CreateFile(string fileName)
        {
            Stream fileStream;

            using (fileStream = File.Open(fileName, FileMode.Create))
            {
                using (StreamWriter sw = new StreamWriter(fileStream))
                {
                    sw.Write("print \"Hello World from SueC\"\r\n");
                    sw.Write("new print here");
                }
            }
            return fileName;
        }

        public string OpenFile(string fileName)
        {
            Stream fileStream;

            using(fileStream = File.OpenRead(fileName))
            {
                return fileName;
            }
            return null;
        }

        public string LoadFile(string fileName)
        {
            string outputStream = null;

            Stream fileStream;
            using (fileStream = File.Open(fileName, FileMode.Open))
            {
                using (StreamReader sr = new StreamReader(fileStream))
                {
                    outputStream = sr.ReadToEnd();
                }
            }
            return outputStream;
        }

        public void SaveFile(string fileName, string codeText)
        {
            Stream fileStream;

            using (fileStream = File.Open(fileName, FileMode.Open))
            {
                fileStream.SetLength(0);
                using (StreamWriter sw = new StreamWriter(fileStream))
                {
                    sw.Flush();
                    sw.Write(codeText);
                }
            }
        }
    }
}
