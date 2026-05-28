function page = dlbsHelpBlockAdam()

page = dlbsHelpPageTemplate("dlbsHelpBlockAdam", "Adam Optimizer");

page.addTitle("Adam Optimizer");
page.setBlockLibraryPath("dlbsBlockAdam/Adam")
page.addBlockImage("block")
page.addParagraphAndMaskHelp("Updates parameters using the Adam optimization algorithm.");
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
page.addParagraph("This block exposes the following parameters:");

parameters = struct.empty;
parameters(1).Name = "Initialization";
parameters(1).Parameter = "init";
parameters(1).Size = "Tensor shape definition";
parameters(1).Type = "Configuration";
parameters(1).Description = "Defines the size and initialization of the optimizer-owned parameter tensor P.";
parameters(2).Name = "Beta1";
parameters(2).Parameter = "beta1";
parameters(2).Size = "Scalar";
parameters(2).Type = "Numeric";
parameters(2).Description = "Exponential decay rate for the first moment estimate.";
parameters(3).Name = "Beta2";
parameters(3).Parameter = "beta2";
parameters(3).Size = "Scalar";
parameters(3).Type = "Numeric";
parameters(3).Description = "Exponential decay rate for the second moment estimate.";
parameters(4).Name = "Epsilon";
parameters(4).Parameter = "epsilon";
parameters(4).Size = "Scalar";
parameters(4).Type = "Numeric";
parameters(4).Description = "Small constant for numerical stability.";
page.addTable(struct2table(parameters))

page.addTitle("Original Paper");
page.addParagraph("Diederik P. Kingma and Jimmy Ba. ""Adam: A Method for Stochastic Optimization.""" + " https://arxiv.org/abs/1412.6980");

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
