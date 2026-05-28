function page = dlbsHelpBlockSquare()

page = dlbsHelpPageTemplate("dlbsHelpBlockSquare", "Square");

page.addTitle("Square");
page.setBlockLibraryPath("dlbsBlockSquare/Square")
page.addBlockImage("block")
page.addParagraphAndMaskHelp("Squares the input tensor. The operation is applied element-wise across all tensor elements.");

page.addTitle("Inputs and Outputs");
io = struct.empty;
io(1).Port = "X";
io(1).Type = "Input (passes gradient)";
io(1).Size = "(d1,d2,...,dn)";
io(1).Description = "Input tensor.";
io(2).Port = "Y";
io(2).Type = "Output (receives gradient)";
io(2).Size = "(d1,d2,...,dn)";
io(2).Description = "Output tensor.";
page.addTable(struct2table(io))

page.addTitle("Parameters");
page.addParagraph("This block has no additional parameters.");

page.addTitle("Mathematical Description");
page.addParagraph("*Forward*");
page.addParagraph("$$Y = X^2$$")

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
