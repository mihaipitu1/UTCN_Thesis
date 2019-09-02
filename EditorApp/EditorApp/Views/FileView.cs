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
    public partial class FileView : Form
    {
        FileController fileController = new FileController();
        public FileView(string fileName)
        {
            InitializeComponent();
            this.Text = fileName;
            LoadCodeTextBox(fileName);
        }

        private void LoadCodeTextBox(string fileName)
        {
            string codeBox = fileController.LoadFile(fileName);
            this.codeTextBox.Text = codeBox;
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

        private void SaveToolStripMenuItem_Click(object sender, EventArgs e)
        {
            string fileName = this.Text;
            string codeText = this.codeTextBox.Text;

            Console.WriteLine("This is the codeText: \n\n" + codeText + "\n\n");

            fileController.SaveFile(fileName, codeText);
        }
    }
}
