using SueC_Editor.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SueC_Editor.ViewModels
{
    public class SourceFileViewModel
    {
        public ObservableCollection<SourceFile> SourceFiles
        {
            get;
            set;
        }

        public void LoadSourceFiles()
        {
            ObservableCollection<SourceFile> sourceFiles = new ObservableCollection<SourceFile>();

            sourceFiles.Add(new SourceFile { Title = "title",PathName = "path",Content = "something"});
            SourceFiles = sourceFiles;
        }
    }
}
