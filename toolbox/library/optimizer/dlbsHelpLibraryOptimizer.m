function page = dlbsHelpLibraryOptimizer()

page = dlbsHelpPageTemplate("dlbsHelpLibraryOptimizer", "Optimizer");

page.addTitle("Optimizer");
page.addParagraph("Optimizer blocks hold learnable parameters and execute parameter updates. Their learning-rate input is a scalar control signal, not a tensor feature input.");

page.addParagraph("*Blocks:*")
page.addList(...
    page.internalLink("dlbsHelpBlockSgd", "SGD Optimizer"), ...
    page.internalLink("dlbsHelpBlockAdam", "Adam Optimizer"), ...
    page.internalLink("dlbsHelpBlockParameterUpdate", "Parameter Update"));

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
