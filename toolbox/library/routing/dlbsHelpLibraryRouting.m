function page = dlbsHelpLibraryRouting()

page = dlbsHelpPageTemplate("dlbsHelpLibraryRouting", "Routing");

page.addTitle("Routing");
page.addParagraph("Routing blocks split, slice, and concatenate tensors and route corresponding gradients through matching tensor transformations.");

page.addParagraph("*Blocks:*")
page.addList(...
    page.internalLink("dlbsHelpBlockSplit", "Split"), ...
    page.internalLink("dlbsHelpBlockConcatenate", "Concatenate"), ...
    page.internalLink("dlbsHelpBlockSlice", "Slice"));

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
