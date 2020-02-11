using EditorApp.Utilities;
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
        FileUtility fileUtility = new FileUtility();
        public string CreateFile()
        {
            SaveFileDialog saveFileDialog = new SaveFileDialog();

            if(saveFileDialog.ShowDialog() == DialogResult.OK)
            {
                return fileUtility.CreateFile(saveFileDialog.FileName);
            }
            return null;
        }

        public string OpenFile()
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
            
            if(openFileDialog.ShowDialog() == DialogResult.OK)
            {
                return fileUtility.OpenFile(openFileDialog.FileName);
            }
            return null;
        }

        public string LoadFile(string fileName)
        {
            return fileUtility.LoadFile(fileName);
        }

        public void SaveFile(string fileName, string codeText)
        {
            fileUtility.SaveFile(fileName, codeText);
        }
    }
}
