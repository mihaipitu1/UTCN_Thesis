using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace EditorApp.Controllers
{
    public class FileController
    {
        public string CreateFile()
        {
            Stream fileStream;
            SaveFileDialog saveFileDialog = new SaveFileDialog();

            if(saveFileDialog.ShowDialog() == DialogResult.OK)
            {
                using (fileStream = File.Open(saveFileDialog.FileName, FileMode.Create))
                {
                    using(StreamWriter sw = new StreamWriter(fileStream))
                    {
                        sw.Write("print \"Hello World from SueC\"\r\n");
                        sw.Write("new print here");
                    }
                    return saveFileDialog.FileName;
                }
            }
            return null;
        }

        public string OpenFile()
        {
            Stream fileStream;
            OpenFileDialog openFileDialog = new OpenFileDialog();
            
            if(openFileDialog.ShowDialog() == DialogResult.OK)
            {
                using (fileStream = File.OpenRead(openFileDialog.FileName))
                {
                    Console.WriteLine("File with path: " + openFileDialog.FileName + " is opened");
                    return openFileDialog.FileName;
                }
            }
            return null;
        }

        public string LoadFile(string fileName)
        {
            string outputStream = null;

            Stream fileStream;
            using(fileStream = File.OpenRead(fileName))
            {
                using(StreamReader sr = new StreamReader(fileStream))
                {
                    outputStream = sr.ReadToEnd();
                }
            }

            return outputStream;
        }
    }
}
