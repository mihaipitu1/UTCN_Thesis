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
    public partial class BaseView : Form
    {
        FileController fileController;
        public BaseView()
        {
            InitializeComponent();
            fileController = new FileController();
        }

        protected void newToolStripMenuItem_Click(object sender, EventArgs e)
        {
            string fileName = fileController.CreateFile();
            FileView fileView = new FileView(fileName);
            fileView.Show();
            this.Hide();
        }

        protected void openToolStripMenuItem_Click(object sender, EventArgs e)
        {
            string fileName = fileController.OpenFile();
            FileView fileView = new FileView(fileName);
            fileView.Show();
            this.Hide();
        }
    }
}
