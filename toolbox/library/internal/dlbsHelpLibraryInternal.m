function page = dlbsHelpLibraryInternal()

page = dlbsHelpPageTemplate("dlbsHelpLibraryInternal", "Internal");

page.addTitle("Internal");
page.addParagraph("Internal blocks create global Goto/From gradient connections so gradient signals can be routed back alongside Simulink forward routing.");
page.addParagraph("How these blocks pair and synchronize tags is implemented in their mask files.");

page.addParagraph("*Blocks:*")
page.addList(...
    page.internalLink("dlbsHelpBlockInsertGradientGF", "Insert Gradient"), ...
    page.internalLink("dlbsHelpBlockExtractGradientGF", "Extract Gradient"));

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
