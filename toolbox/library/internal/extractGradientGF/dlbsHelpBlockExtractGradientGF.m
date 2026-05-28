function page = dlbsHelpBlockExtractGradientGF()

page = dlbsHelpPageTemplate("dlbsHelpBlockExtractGradientGF", "Extract Gradient");

page.addTitle("Extract Gradient");
page.setBlockLibraryPath("dlbsBlockExtractGradientGF/extractGradientGF")
page.addBlockImage("block")
page.addParagraphAndMaskHelp("Internal utility block that extracts a gradient signal from a forward-routed value signal.");
page.addParagraphAndMaskHelp("The block cooperates with Insert Gradient by discovering the connected insertion point and synchronizing Goto/From tags in mask initialization.");

page.addTitle("Inputs and Outputs");
io = struct.empty;
io(1).Port = "value";
io(1).Type = "Input (internal routing)";
io(1).Size = "Tensor";
io(1).Description = "Forward value signal.";
io(2).Port = "valueWithGrad";
io(2).Type = "Output (internal routing)";
io(2).Size = "Tensor";
io(2).Description = "Forward signal with gradient route context.";
io(3).Port = "grad";
io(3).Type = "Output (internal routing)";
io(3).Size = "Tensor";
io(3).Description = "Extracted gradient signal.";
page.addTable(struct2table(io))

page.addTitle("Parameters");
page.addParagraph("This block has no user parameters.");

page.addTitle("Notes");
page.addParagraph("This block is intended for internal use in DLBS library implementations.");

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
