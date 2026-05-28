function page = dlbsHelpBlockSum()

page = dlbsHelpPageTemplate("dlbsHelpBlockSum", "Sum Reduction");

page.addTitle("Sum Reduction");
page.setBlockLibraryPath("dlbsBlockSum/Sum")
page.addBlockImage("block")
page.addParagraphAndMaskHelp("Computes the sum over all elements of an input tensor, producing a scalar output.");

page.addTitle("Inputs and Outputs");
io = struct.empty;
io(1).Port = "X";
io(1).Type = "Input (passes gradient)";
io(1).Size = "(d1,d2,...,dn)";
io(1).Description = "Input tensor.";
io(2).Port = "Y";
io(2).Type = "Output (receives gradient)";
io(2).Size = "Scalar";
io(2).Description = "Sum over all elements of X.";
page.addTable(struct2table(io))

page.addTitle("Parameters");
page.addParagraph("This block has no additional parameters.");

page.addTitle("Mathematical Description");
page.addParagraph("*Forward*");
page.addParagraph("$$Y = \sum_{i=1}^{N} X_i$$")

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
