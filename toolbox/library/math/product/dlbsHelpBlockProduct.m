function page = dlbsHelpBlockProduct()

page = dlbsHelpPageTemplate("dlbsHelpBlockProduct", "Product");

page.addTitle("Product");
page.setBlockLibraryPath("dlbsBlockProduct/Product")
page.addBlockImage("block")
page.addParagraphAndMaskHelp("Computes element-wise multiplication of two input tensors.");

page.addTitle("Inputs and Outputs");
io = struct.empty;
io(1).Port = "X1";
io(1).Type = "Input (passes gradient)";
io(1).Size = "(d1,d2,...,dn)";
io(1).Description = "First input tensor.";
io(2).Port = "X2";
io(2).Type = "Input (passes gradient)";
io(2).Size = "(d1,d2,...,dn)";
io(2).Description = "Second input tensor. Must match the size of X1.";
io(3).Port = "Y";
io(3).Type = "Output (receives gradient)";
io(3).Size = "(d1,d2,...,dn)";
io(3).Description = "Output tensor.";
page.addTable(struct2table(io))

page.addTitle("Parameters");
page.addParagraph("This block has no additional parameters.");

page.addTitle("Mathematical Description");
page.addParagraph("*Forward*");
page.addParagraph("$$Y = X_1 \odot X_2$$")

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
