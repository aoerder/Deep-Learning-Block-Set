function page = dlbsHelpLibraryNonlinearActivation()

page = dlbsHelpPageTemplate("dlbsHelpLibraryNonlinearActivation", "Nonlinear Activation");

page.addTitle("Nonlinear Activation");
page.addParagraph("Nonlinear activation blocks apply element-wise nonlinear transformations. They are key for expressive deep learning models and provide corresponding backward behavior.");

page.addParagraph("*Blocks:*")
page.addList(...
    page.internalLink("dlbsHelpBlockRelu", "ReLU"), ...
    page.internalLink("dlbsHelpBlockSigmoid", "Sigmoid"), ...
    page.internalLink("dlbsHelpBlockTanh", "Tanh"));

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
