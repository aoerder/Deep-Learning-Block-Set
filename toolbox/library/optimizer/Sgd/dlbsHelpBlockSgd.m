function page = dlbsHelpBlockSgd()

page = dlbsHelpPageTemplate("dlbsHelpBlockSgd", "SGD Optimizer");

page.addTitle("SGD Optimizer");
page.setBlockLibraryPath("dlbsBlockSgd/SGD")
page.addBlockImage("block")
page.addParagraphAndMaskHelp("Updates parameters using stochastic gradient descent.");
page.addParagraphAndMaskHelp("Learnable parameters are owned by the optimizer. The output parameter tensor P is created and sized according to the init parameter.");

page.addTitle("Inputs and Outputs");
io = struct.empty;
io(1).Port = "lr";
io(1).Type = "Input (no gradient)";
io(1).Size = "Scalar";
io(1).Description = "Learning rate.";
io(2).Port = "P";
io(2).Type = "Output (receives gradient)";
io(2).Size = "Variable tensor";
io(2).Description = "Optimizer-owned parameter tensor. Size is specified by init.";
page.addTable(struct2table(io))

page.addTitle("Parameters");
page.addParagraph("This block exposes the following parameter:");

parameters = struct.empty;
parameters(1).Name = "Initialization";
parameters(1).Parameter = "init";
parameters(1).Size = "Tensor shape definition";
parameters(1).Type = "Configuration";
parameters(1).Description = "Defines the size and initialization of the optimizer-owned parameter tensor P.";
page.addTable(struct2table(parameters))

page.addTitle("Mathematical Description");
page.addParagraph("*Parameter Update*");
page.addParagraph("$$P_t = P_{t-1} - lr \cdot g_t$$")

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
