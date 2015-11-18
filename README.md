# BPCA_Directory
A project to automatically create a directory, such as for a neighborhood, based on a Google sheet. This uses RMarkdown, Pandoc, LaTeX, and R, and knits to a PDF.

There are three key files. The first is `Directory.Rmd` which is the markdown file for the Directory. In this case, it's meant for Battery Park, where I live. The second is `executable.R`, which is what `Directory.Rmd` calls to do the main data manipulation. Finally, this is heavily functionalized, and each function is located in `utilities.R`. 

You will need a Google spreadsheet with the following columns: 
[1] "LastName1"      "FirstName1"     "LastName2"      "FirstName2"     "LastName3"     
[6] "FirstName3"     "LastName4"      "FirstName4"     "ChildName1"     "ChildYearBorn1"
[11] "ChildName2"     "ChildYearBorn2" "ChildName3"     "ChildYearBorn3" "ChildName4"    
[16] "ChildYearBorn4" "ChildName5"     "ChildYearBorn5" "ChildName6"     "ChildYearBorn6"
[21] "StreetNumber"   "StreetName"     "HomePhone"      "CellPhone1"     "CellPhone2"    
[26] "Email1"         "Email2" 

Of course, this can be customized. I would kindly ask that if you do a pull request, you add fields and not subtract them, and handle them appropriately as additions in the code, and do not rename fields.

To access the spreadsheet, you'll need the public share address. To keep privacy, this is stored in a text file in the same directory called `sheetLocation`. Just store this as plain text.

You will also need to have Pandoc installed on your computer to run PDFs via LaTeX.


To run, just hit "knit" from Rstudio on the Rmd.
