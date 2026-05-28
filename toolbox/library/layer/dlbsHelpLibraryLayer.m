function page = dlbsHelpLibraryLayer()

page = dlbsHelpPageTemplate("dlbsHelpLibraryLayer", "Layer");

page.addTitle("Layer");
page.addParagraph("Common layers used in deep neural networks. Layer blocks transform tensors and typically own the core architecture of a model.");

page.addParagraph("*Blocks:*")
page.addList(...
    page.internalLink("dlbsHelpBlockDenseLayer", "Dense Layer"));

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
