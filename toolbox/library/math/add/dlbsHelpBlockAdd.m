function page = dlbsHelpBlockAdd()

page = dlbsHelpPageTemplate("dlbsHelpBlockAdd", "Add");
            
page.addTitle("Add");
page.setBlockLibraryPath("dlbsBlockAdd/Add")
page.addBlockImage("block")
page.addParagraphAndMaskHelp("Adds two inputs element-wise.");
page.addParagraphAndMaskHelp("This block supports broadcasting, which allows it to add tensors of different sizes together under certain conditions.");
page.addParagraphAndMaskHelp("When broadcasting is enabled, the block can automatically expand certain dimensions of the input tensors to make their sizes compatible for element-wise addition. These dimensions must be of length 1 and must be specified using the 'Dimensions to sum over' parameters for each input.");

page.addTitle("Inputs and Outputs");
io = struct.empty;
io(1).Port = "X1";
io(1).Type = "Input (passes gradient)";
io(1).Size = "(d1_x1,d2_x1,...,dn_x1)";
io(1).Description = "First input tensor";
io(2).Port = "X2";
io(2).Type = "Input (passes gradient)";
io(2).Size = "(d1_x2,d2_x2,...,dn_x2)";
io(2).Description = "Second input tensor";
io(3).Port = "Y";
io(3).Type = "Output (receives gradient)";
io(3).Size = "(d1_y,d2_y,...,dn_y)";
io(3).Description = "Output tensor, element-wise sum of inputs";
page.addTable(struct2table(io))

page.addTitle("Parameters");
page.addParagraph("This block exposes the following parameters:");

parameters=struct.empty;
parameters(1).Name = "Broadcast Dimensions";
parameters(1).Parameter = "broadcast";
parameters(1).Size = "Scalar";
parameters(1).Type = "Logical";
parameters(1).Description = "Controls whether to apply broadcasting.";
parameters(2).Name = "Dimensions to sum over X1";
parameters(2).Parameter = "dims1";
parameters(2).Size = "Vector";
parameters(2).Type = "Vector of indices";
parameters(2).Description = "Specifies the dimensions to sum over for the first input. In this dimension, the input X1 must have a length of 1 for  all dimensions specified in this parameter.";
parameters(3).Name = "Dimensions to sum over X2";
parameters(3).Parameter = "dims2";
parameters(3).Size = "Vector";
parameters(3).Type = "Vector of indices";
parameters(3).Description = "Specifies the dimensions to sum over for the second input. In this dimension, the input X2 must have a length of 1 for  all dimensions specified in this parameter.";
page.addTable(struct2table(parameters))

page.addTitle("Mathematical Description");

page.addParagraph("*Forward*");
page.addParagraph("$$Y = X_1 + X_2$$")

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
