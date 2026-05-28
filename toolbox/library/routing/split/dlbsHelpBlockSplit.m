function page = dlbsHelpBlockSplit()

page = dlbsHelpPageTemplate("dlbsHelpBlockSplit", "Split");

page.addTitle("Split");
page.setBlockLibraryPath("dlbsBlockSplit/Split")
page.addBlockImage("block")
page.addParagraphAndMaskHelp("Copies one input tensor to multiple outputs. The input gradient is computed as the sum of contributing output gradients.");

page.addTitle("Inputs and Outputs");
io = struct.empty;
io(1).Port = "X";
io(1).Type = "Input (passes gradient)";
io(1).Size = "(d1,d2,...,dn)";
io(1).Description = "Input tensor.";
io(2).Port = "Y1";
io(2).Type = "Output (receives gradient)";
io(2).Size = "(d1,d2,...,dn)";
io(2).Description = "First output copy.";
io(3).Port = "Y2";
io(3).Type = "Output (receives gradient)";
io(3).Size = "(d1,d2,...,dn)";
io(3).Description = "Second output copy.";
io(4).Port = "Y3";
io(4).Type = "Output (optional, receives gradient)";
io(4).Size = "(d1,d2,...,dn)";
io(4).Description = "Third output copy (active if Number of Outputs >= 3).";
io(5).Port = "Y4";
io(5).Type = "Output (optional, receives gradient)";
io(5).Size = "(d1,d2,...,dn)";
io(5).Description = "Fourth output copy (active if Number of Outputs >= 4).";
page.addTable(struct2table(io))

page.addTitle("Parameters");
page.addParagraph("This block exposes the following parameter:");

parameters = struct.empty;
parameters(1).Name = "Number of Outputs";
parameters(1).Parameter = "n_out";
parameters(1).Size = "Scalar";
parameters(1).Type = "Integer (2-4)";
parameters(1).Description = "Number of active output ports.";
parameters(2).Name = "Output 1 contributes to gradient";
parameters(2).Parameter = "";
parameters(2).Size = "Scalar";
parameters(2).Type = "Boolean";
parameters(2).Description = "Whether the first output contributes to the gradient.";
parameters(3).Name = "Output 2 contributes to gradient";
parameters(3).Parameter = "";
parameters(3).Size = "Scalar";
parameters(3).Type = "Boolean";
parameters(3).Description = "Whether the second output contributes to the gradient.";
parameters(4).Name = "Output 3 contributes to gradient";
parameters(4).Parameter = "";
parameters(4).Size = "Scalar";
parameters(4).Type = "Boolean";
parameters(4).Description = "Whether the third output contributes to the gradient.";
parameters(5).Name = "Output 4 contributes to gradient";
parameters(5).Parameter = "";
parameters(5).Size = "Scalar";
parameters(5).Type = "Boolean";
parameters(5).Description = "Whether the fourth output contributes to the gradient.";

page.addTable(struct2table(parameters))

page.addTitle("Mathematical Description");
page.addParagraph("*Forward*");
page.addParagraph("$$Y_i = X$$")
page.addParagraph("*Backward*");
page.addParagraph("$$dX = \sum_i dY_i$$")
page.addParagraph("All output gradients are configured as contributing in this block configuration.");

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
