function page = dlbsHelpBlockBceLoss()

page = dlbsHelpPageTemplate("dlbsHelpBlockBceLoss", "Binary Cross-Entropy Loss");

page.addTitle("Binary Cross-Entropy Loss");
page.setBlockLibraryPath("dlbsBlockBceLoss/BCE Loss")
page.addBlockImage("block")

page.addParagraphAndMaskHelp("The Binary Cross-Entropy (BCE) Loss block computes the element-wise binary cross-entropy between a prediction tensor and a reference tensor, and outputs a scalar loss value.");

page.addTitle("Inputs and Outputs");
io = struct.empty;
io(1).Port = "Y";
io(1).Type = "Input (passes gradient)";
io(1).Size = "(d1,d2,...,dn)";
io(1).Description = "Prediction tensor.";
io(2).Port = "Y_ref";
io(2).Type = "Input";
io(2).Size = "(d1,d2,...,dn)";
io(2).Description = "Reference tensor. Must match the size of Y.";
io(3).Port = "L";
io(3).Type = "Output (no gradient)";
io(3).Size = "Scalar";
io(3).Description = "Loss value.";
page.addTable(struct2table(io))

page.addTitle("Parameters");
page.addParagraph("This block has no additional parameters.");

page.addTitle("Mathematical Description");
page.addParagraph("*Forward*");
page.addParagraph("$$L = -\frac{1}{N}\sum_{i=1}^{N}\left(Y_{ref,i}\log(Y_i) + (1-Y_{ref,i})\log(1-Y_i)\right)$$")

page.addParagraph("The input tensors Y and Y_ref must have identical size (d1,d2,...,dn). The reduction is set to mean, so the block returns the average BCE over all N elements in the tensor.");

if nargout == 0 % preview, if run with F5
	page.preview()
end

end
