function page = dlbsHelpBlockMatrixMultiply()

page = dlbsHelpPageTemplate("dlbsHelpBlockMatrixMultiply", "Matrix Multiply");

page.addTitle("Matrix Multiply");
page.setBlockLibraryPath("dlbsBlockMatrixMultiply/Matrix Multiply")
page.addBlockImage("block")
page.addParagraphAndMaskHelp("Performs matrix multiplication between two compatible input matrices.");

page.addTitle("Inputs and Outputs");
io = struct.empty;
io(1).Port = "X";
io(1).Type = "Input (passes gradient)";
io(1).Size = "(m,n)";
io(1).Description = "Left input matrix.";
io(2).Port = "W";
io(2).Type = "Input (passes gradient)";
io(2).Size = "(n,p)";
io(2).Description = "Right input matrix.";
io(3).Port = "Y";
io(3).Type = "Output (receives gradient)";
io(3).Size = "(m,p)";
io(3).Description = "Output matrix product.";
page.addTable(struct2table(io))

page.addTitle("Parameters");
page.addParagraph("This block has no additional parameters.");

page.addTitle("Mathematical Description");
page.addParagraph("*Forward*");
page.addParagraph("$$Y = XW$$")

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
