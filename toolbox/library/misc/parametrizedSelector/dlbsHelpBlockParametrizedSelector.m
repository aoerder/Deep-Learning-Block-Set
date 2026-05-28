function page = dlbsHelpBlockParametrizedSelector()

page = dlbsHelpPageTemplate("dlbsHelpBlockParametrizedSelector", "Parametrized Selector");

page.addTitle("Parametrized Selector");
page.setBlockLibraryPath("dlbsBlockParametrizedSelector/Parametrized Selector")
page.addBlockImage("block")
page.addParagraphAndMaskHelp("Selects a configurable index interval from one selected dimension of the input.");
page.addParagraphAndMaskHelp("This block is a no-gradient operation and does not pass gradients back.");

page.addTitle("Inputs and Outputs");
io = struct.empty;
io(1).Port = "X";
io(1).Type = "Input (no gradient)";
io(1).Size = "(d1,d2,...,dn)";
io(1).Description = "Input tensor to slice.";
io(2).Port = "Y";
io(2).Type = "Output (no gradient)";
io(2).Size = "(d1,...,idx2-idx1+1,...,dn)";
io(2).Description = "Selected interval along dimension dim.";
page.addTable(struct2table(io))

page.addTitle("Parameters");
page.addParagraph("This block exposes the following parameters:");

parameters = struct.empty;
parameters(1).Name = "Number of Dimensions";
parameters(1).Parameter = "all_dims";
parameters(1).Size = "Scalar";
parameters(1).Type = "Positive integer";
parameters(1).Description = "Total number of dimensions considered by the selector.";
parameters(2).Name = "Dimension to select from";
parameters(2).Parameter = "dim";
parameters(2).Size = "Scalar";
parameters(2).Type = "Positive integer";
parameters(2).Description = "Dimension along which idx1:idx2 is applied.";
parameters(3).Name = "Lower index";
parameters(3).Parameter = "idx1";
parameters(3).Size = "Scalar";
parameters(3).Type = "Positive integer";
parameters(3).Description = "Lower bound of selected index interval.";
parameters(4).Name = "Higher index";
parameters(4).Parameter = "idx2";
parameters(4).Size = "Scalar";
parameters(4).Type = "Positive integer";
parameters(4).Description = "Upper bound of selected index interval. Must satisfy idx2 >= idx1.";
page.addTable(struct2table(parameters))

page.addTitle("Mathematical Description");
page.addParagraph("*Forward*");
page.addParagraph("$$Y = X(:,:,\ldots, idx1:idx2, \ldots,:)$$")
page.addParagraph("where the interval idx1:idx2 is applied along dimension dim.");

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
