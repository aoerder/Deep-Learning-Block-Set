function page = dlbsHelpBlockInsertGradientGF()

page = dlbsHelpPageTemplate("dlbsHelpBlockInsertGradientGF", "Insert Gradient");

page.addTitle("Insert Gradient");
page.setBlockLibraryPath("dlbsBlockInsertGradientGF/insertGradientGF")
page.addBlockImage("block")
page.addParagraphAndMaskHelp("Internal utility block that inserts a gradient signal into a forward-routed value signal.");
page.addParagraphAndMaskHelp("The block cooperates with Extract Gradient by configuring unique Goto/From tags in its mask initialization.");

page.addTitle("Inputs and Outputs");
io = struct.empty;
io(1).Port = "valueWithGrad";
io(1).Type = "Input (internal routing)";
io(1).Size = "Tensor";
io(1).Description = "Forward signal carrying the paired gradient route context.";
io(2).Port = "grad";
io(2).Type = "Input (internal routing)";
io(2).Size = "Tensor";
io(2).Description = "Gradient signal to be inserted into the paired route.";
io(3).Port = "value";
io(3).Type = "Output (internal routing)";
io(3).Size = "Tensor";
io(3).Description = "Forward value signal without explicit gradient port.";
page.addTable(struct2table(io))

page.addTitle("Parameters");
page.addParagraph("This block has no user parameters.");

page.addTitle("Notes");
page.addParagraph("This block is intended for internal use in DLBS library implementations.");

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
