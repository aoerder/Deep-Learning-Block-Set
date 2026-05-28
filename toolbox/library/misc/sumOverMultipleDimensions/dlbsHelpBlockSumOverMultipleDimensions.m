function page = dlbsHelpBlockSumOverMultipleDimensions()

page = dlbsHelpPageTemplate("dlbsHelpBlockSumOverMultipleDimensions", "Sum Over Multiple Dimensions");

page.addTitle("Sum Over Multiple Dimensions");
page.setBlockLibraryPath("dlbsBlockSumOverMultipleDimensions/Sum Over Multiple Dimensions")
page.addBlockImage("block")
page.addParagraphAndMaskHelp("Sums an input tensor over a user-defined set of dimensions.");
page.addParagraphAndMaskHelp("This block is a no-gradient operation and does not pass gradients back.");

page.addTitle("Inputs and Outputs");
io = struct.empty;
io(1).Port = "X";
io(1).Type = "Input (no gradient)";
io(1).Size = "(d1,d2,...,dn)";
io(1).Description = "Input tensor.";
io(2).Port = "Y";
io(2).Type = "Output (no gradient)";
io(2).Size = "Tensor reduced over dims";
io(2).Description = "Reduced tensor after summation across selected dimensions.";
page.addTable(struct2table(io))

page.addTitle("Parameters");
page.addParagraph("This block exposes the following parameter:");

parameters = struct.empty;
parameters(1).Name = "Dimensions to sum over";
parameters(1).Parameter = "dims";
parameters(1).Size = "Scalar or row vector";
parameters(1).Type = "Positive integers (unique, <= 8)";
parameters(1).Description = "List of dimensions that are reduced by summation.";
page.addTable(struct2table(parameters))

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
