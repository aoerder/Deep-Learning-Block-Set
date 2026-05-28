function page = dlbsHelpLibraryMisc()

page = dlbsHelpPageTemplate("dlbsHelpLibraryMisc", "Misc");

page.addTitle("Misc");
page.addParagraph("The Misc library contains utility blocks for model construction, debugging, and non-gradient utility operations.");

page.addTitle("Specify Dimensions");
page.addParagraph("Specify Dimensions lets you set the tensor size of the forward value and gradient value explicitly. This helps debugging and supports signal-width propagation in Simulink.");
page.addParagraph("*Blocks:*")
page.addList(...
    page.internalLink("dlbsHelpBlockSpecifyDimensions", "Specify Dimensions"));

page.addTitle("No-Gradient Operations");
page.addParagraph("These blocks are not acting on gradient-carrying tensors and do not pass back gradients.");
page.addParagraph("*Blocks:*")
page.addList(...
    page.internalLink("dlbsHelpBlockParametrizedSelector", "Parametrized Selector"), ...
    page.internalLink("dlbsHelpBlockSumOverMultipleDimensions", "Sum Over Multiple Dimensions"));

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
