using EditorApp.Controllers;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace EditorApp.Views
{
    public partial class FileView : BaseView
    {
        FileController fileController = new FileController();
        public FileView(string fileName)
        {
            InitializeComponent();
            this.Text = fileName;
            LoadCodeBox(fileName);
        }

        private void LoadCodeBox(string fileName)
        {
            string codeBox = fileController.LoadFile(fileName);
            this.codeBox.Text = codeBox;
        }
    }
}
