using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SueC_Editor.Models
{
    public class SourceFile : INotifyPropertyChanged
    {
        private string title;
        private string pathName;
        private string content;

        public string Title
        {
            get => title;
            set
            {
                title = value;
                RaisePropertyChanged("Title");
            }
        }

        public string PathName
        {
            get => pathName;
            set
            {
                pathName = value;
                RaisePropertyChanged("PathName");
            }
        }

        public string Content
        {
            get => content;
            set
            {
                content = value;
                RaisePropertyChanged("Content");
            }
        }

        #region "PropertyEvents"

        public event PropertyChangedEventHandler PropertyChanged;
        private void RaisePropertyChanged(string property)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(property));
            }
        }
        #endregion

    }
}
