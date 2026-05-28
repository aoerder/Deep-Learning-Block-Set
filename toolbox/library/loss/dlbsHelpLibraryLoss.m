function page = dlbsHelpLibraryLoss()

page = dlbsHelpPageTemplate("dlbsHelpLibraryLoss", "Loss");

page.addTitle("Loss");
page.addParagraph("Loss functions compute scalar objective values and define the source of the backward path. They do not output regular feature tensors.");

page.addParagraph("*Blocks:*")
page.addList(...
    page.internalLink("dlbsHelpBlockBceLoss", "Binary Cross Entropy Loss"), ...
    page.internalLink("dlbsHelpBlockMseLoss", "Mean Squared Error Loss"));

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
