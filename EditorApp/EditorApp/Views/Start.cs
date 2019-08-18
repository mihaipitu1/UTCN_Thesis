using EditorApp.Controllers;
using EditorApp.Views;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace EditorApp
{
    public partial class Start : Form
    {
        FileController fileController;
        public Start()
        {
            InitializeComponent();
            fileController = new FileController();
        }

        private void NewToolStripMenuItem_Click(object sender, EventArgs e)
        {
            string fileName = fileController.CreateFile();
            FileView flView = new FileView(fileName);
            flView.Show();
            this.Hide();
        }

        private void OpenToolStripMenuItem_Click(object sender, EventArgs e)
        {
            string fileName = fileController.OpenFile();
            FileView flView = new FileView(fileName);
            flView.Show();
            this.Hide();
        }
    }
}
