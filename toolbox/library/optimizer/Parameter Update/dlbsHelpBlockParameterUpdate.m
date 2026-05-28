function page = dlbsHelpBlockParameterUpdate()

page = dlbsHelpPageTemplate("dlbsHelpBlockParameterUpdate", "Parameter Update");

page.addTitle("Parameter Update");
page.setBlockLibraryPath("dlbsBlockParameterUpdate/Parameter Update")
page.addBlockImage("block")
page.addParagraphAndMaskHelp("Updates an parameter P state using a source tensor S and mixing factor tau.");

page.addTitle("Inputs and Outputs");
io = struct.empty;
io(1).Port = "tau";
io(1).Type = "Input (no gradient)";
io(1).Size = "Scalar";
io(1).Description = "Update factor.";
io(2).Port = "S";
io(2).Type = "Input (provides gradient which isalways zero)";
io(2).Size = "(d1,d2,...,dn)";
io(2).Description = "Source tensor. This input can sink a tensor but always returns a gradient of zeros.";
io(3).Port = "P";
io(3).Type = "Output (receives gradient, not used)";
io(3).Size = "(d1,d2,...,dn)";
io(3).Description = "Updated parameter tensor. Downstream gradients on P are not read by this block.";
page.addTable(struct2table(io))

page.addTitle("Parameters");
page.addParagraph("This block has no additional parameters.");

page.addTitle("Mathematical Description");
page.addParagraph("*Update rule*");
page.addParagraph("$$T_t = T_{t-1}(1-\tau) + S\tau$$")
page.addParagraph("Sizes of S and P are equal by propagation.");

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
