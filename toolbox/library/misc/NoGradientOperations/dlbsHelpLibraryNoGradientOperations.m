function page = dlbsHelpLibraryNoGradientOperations()

page = dlbsHelpPageTemplate("dlbsHelpLibraryNoGradientOperations", "No-Gradient Operations");

page.addTitle("No-Gradient Operations");
page.addParagraph("No-Gradient Operations contains utility blocks that are not acting on gradient-carrying tensors and do not pass gradients back.");

page.addParagraph("*Blocks:*")
page.addList(...
    page.internalLink("dlbsHelpBlockParametrizedSelector", "Parametrized Selector"), ...
    page.internalLink("dlbsHelpBlockSumOverMultipleDimensions", "Sum Over Multiple Dimensions"));

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
