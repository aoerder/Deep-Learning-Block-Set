function page = dlbsHelpBlockDenseLayer()
page = dlbsHelpPageTemplate("dlbsHelpBlockDenseLayer", "Dense Layer");
page.addTitle("Dense Layer");
page.setBlockLibraryPath("dlbsBlockDenseLayer/Dense Layer")
page.addBlockImage("block")

page.addParagraphAndMaskHelp("The Dense Layer block implements a fully connected layer, which is a fundamental building block in many neural network architectures. It performs a linear transformation of the input data followed by an optional activation function.");

page.addTitle("Inputs and Outputs");
io = struct.empty;
io(1).Port = "X";
io(1).Type = "Input (passes gradient)";
io(1).Size = "(d1,d2_in)";
io(1).Description = "Input tensor, where d1 is the batch size and d2_in is the input feature dimension.";
io(2).Port = "Y";
io(2).Type = "Output (receives gradient)";
io(2).Size = "(d1,d2_out)";
io(2).Description = "Output tensor, where d1 is the batch size and d2_out is the output feature dimension.";
io(3).Port = "W";
io(3).Type = "Input (passes gradient)";
io(3).Size = "(d2_in,d2_out)";
io(3).Description = "Weight matrix for the linear transformation.";
io(4).Port = "b";
io(4).Type = "Input (passes gradient)";
io(4).Size = "(1,d2_out)";
io(4).Description = "Bias vector for the linear transformation.";

page.addTable(struct2table(io))

page.addTitle("Parameters");
page.addParagraph("This block has no additional parameters beyond the weights and biases provided at the input ports.");

page.addTitle("Mathematical Description");
page.addParagraph("*Forward*");
page.addMonospaced("Y = X*W + b")


if nargout == 0 % preview, if run with F5
    page.preview()
end

end