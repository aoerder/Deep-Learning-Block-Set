function page = dlbsHelpBlockSpecifyDimensions()

page = dlbsHelpPageTemplate("dlbsHelpBlockSpecifyDimensions", "Specify Dimensions");

page.addTitle("Specify Dimensions");
page.setBlockLibraryPath("dlbsBlockSpecifyDimensions/Specify Dimensions")
page.addBlockImage("block")
page.addParagraphAndMaskHelp("Passes the input value through while explicitly constraining value and gradient signal dimensions.");
page.addParagraphAndMaskHelp("This block is useful for debugging and for stabilizing signal width propagation in Simulink models.");

page.addTitle("Inputs and Outputs");
io = struct.empty;
io(1).Port = "X";
io(1).Type = "Input (passes gradient)";
io(1).Size = "Configured by value_size";
io(1).Description = "Input tensor to be constrained.";
io(2).Port = "Y";
io(2).Type = "Output (receives gradient)";
io(2).Size = "Configured by value_size";
io(2).Description = "Output tensor with constrained forward and backward dimensions.";
page.addTable(struct2table(io))

page.addTitle("Parameters");
page.addParagraph("This block exposes the following parameters:");

parameters = struct.empty;
parameters(1).Name = "Value size";
parameters(1).Parameter = "value_size";
parameters(1).Size = "Vector";
parameters(1).Type = "Dimension specification";
parameters(1).Description = "Forward value tensor dimensions.";
parameters(2).Name = "Gradient size";
parameters(2).Parameter = "grad_size";
parameters(2).Size = "Vector";
parameters(2).Type = "Dimension specification";
parameters(2).Description = "Backward gradient tensor dimensions.";
page.addTable(struct2table(parameters))

page.addTitle("Mathematical Description");
page.addParagraph("*Forward*");
page.addParagraph("$$Y = X$$")
page.addParagraph("*Backward*");
page.addParagraph("$$dX = dY$$")
page.addParagraph("Forward and backward signals are additionally constrained to value_size and grad_size.");

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
