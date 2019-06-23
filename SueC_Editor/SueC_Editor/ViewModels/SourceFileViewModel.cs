using SueC_Editor.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;

namespace SueC_Editor.ViewModels
{
    public class SourceFileViewModel
    {
        public SourceFile SF = new SourceFile()
        {
            Title = "some title",
            LocationURL = "URL",
            Content = "This is some content \nHere is another"
        };

        public List<SourceFile> SFList = new List<SourceFile>();

        public SourceFileViewModel()
        {
            SFList.Add(SF);
        }
        private ICommand listCmd;

        public ICommand LstCommand
        {
            get
            {
                if (listCmd == null)
                {
                    listCmd = new ListCommand();
                }
                return listCmd;
            }
            set
            {
                listCmd = value;
            }
        }


        private class ListCommand : ICommand
        {
            public event EventHandler CanExecuteChanged;

            public bool CanExecute(object parameter)
            {
                throw new NotImplementedException();
            }

            public void Execute(object parameter)
            {
                throw new NotImplementedException();
            }
        }
    }
}
