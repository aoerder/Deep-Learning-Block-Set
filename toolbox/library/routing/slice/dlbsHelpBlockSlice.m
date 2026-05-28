function page = dlbsHelpBlockSlice()

page = dlbsHelpPageTemplate("dlbsHelpBlockSlice", "Slice");

page.addTitle("Slice");
page.setBlockLibraryPath("dlbsBlockSlice/Slice")
page.addBlockImage("block")
page.addParagraphAndMaskHelp("Slices an input tensor into multiple outputs along a selected working dimension. The user must specify slice lengths for each active output, because these lengths are required to concatenate output gradients back into the input gradient.");
page.addParagraphAndMaskHelp("The last tensor dimension must not be of size 1. If the last dimension would be 1, reduce ALL_DIMS by 1 and omit that trailing singleton dimension. This avoids Simulink implicitly dropping a singleton final dimension.");

page.addTitle("Inputs and Outputs");
io = struct.empty;
io(1).Port = "X";
io(1).Type = "Input (passes gradient)";
io(1).Size = "(d1,...,s1+s2+s3+s4,...,dn)";
io(1).Description = "Input tensor to be sliced (sum includes active slices only).";
io(2).Port = "Y1";
io(2).Type = "Output (receives gradient)";
io(2).Size = "(d1,...,s1,...,dn)";
io(2).Description = "First slice.";
io(3).Port = "Y2";
io(3).Type = "Output (receives gradient)";
io(3).Size = "(d1,...,s2,...,dn)";
io(3).Description = "Second slice.";
io(4).Port = "Y3";
io(4).Type = "Output (optional, receives gradient)";
io(4).Size = "(d1,...,s3,...,dn)";
io(4).Description = "Third slice (active if Number of Outputs >= 3).";
io(5).Port = "Y4";
io(5).Type = "Output (optional, receives gradient)";
io(5).Size = "(d1,...,s4,...,dn)";
io(5).Description = "Fourth slice (active if Number of Outputs >= 4).";
page.addTable(struct2table(io))

page.addTitle("Parameters");
page.addParagraph("This block exposes the following parameters:");

parameters = struct.empty;
parameters(1).Name = "Number of Outputs";
parameters(1).Parameter = "n_out";
parameters(1).Size = "Scalar";
parameters(1).Type = "Integer (2-4)";
parameters(1).Description = "Number of active output ports.";
parameters(2).Name = "Number of Dimensions";
parameters(2).Parameter = "ALL_DIMS";
parameters(2).Size = "Scalar";
parameters(2).Type = "Integer";
parameters(2).Description = "Number of tensor dimensions used for routing. If the last dimension is singleton, set ALL_DIMS one smaller and omit that dimension.";
parameters(3).Name = "Working Dimension";
parameters(3).Parameter = "DIM";
parameters(3).Size = "Scalar";
parameters(3).Type = "Integer";
parameters(3).Description = "Dimension along which X is sliced.";
parameters(4).Name = "Length of slice 1";
parameters(4).Parameter = "S1";
parameters(4).Size = "Scalar";
parameters(4).Type = "Integer";
parameters(4).Description = "Length of Y1 along DIM.";
parameters(5).Name = "Length of slice 2";
parameters(5).Parameter = "S2";
parameters(5).Size = "Scalar";
parameters(5).Type = "Integer";
parameters(5).Description = "Length of Y2 along DIM.";
parameters(6).Name = "Length of slice 3";
parameters(6).Parameter = "S3";
parameters(6).Size = "Scalar";
parameters(6).Type = "Integer";
parameters(6).Description = "Length of Y3 along DIM (required if Number of Outputs >= 3).";
parameters(7).Name = "Length of slice 4";
parameters(7).Parameter = "S4";
parameters(7).Size = "Scalar";
parameters(7).Type = "Integer";
parameters(7).Description = "Length of Y4 along DIM (required if Number of Outputs >= 4).";
page.addTable(struct2table(parameters))

page.addTitle("Mathematical Description");
page.addParagraph("*Forward*");
page.addParagraph("$$[Y_1, Y_2, Y_3, Y_4] = \mathrm{slice}_{DIM}(X; S_1, S_2, S_3, S_4)$$")
page.addParagraph("*Backward*");
page.addParagraph("$$dX = \mathrm{concat}_{DIM}(dY_1, dY_2, dY_3, dY_4)$$")

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
