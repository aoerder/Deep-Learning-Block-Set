function page = dlbsHelpLibraryReduction()

page = dlbsHelpPageTemplate("dlbsHelpLibraryReduction", "Reduction");

page.addTitle("Reduction");
page.addParagraph("Reduction blocks reduce multidimensional tensors to scalar tensors. They are commonly used for statistics, metrics, and final scalar objectives.");

page.addParagraph("*Blocks:*")
page.addList(...
    page.internalLink("dlbsHelpBlockSum", "Sum"), ...
    page.internalLink("dlbsHelpBlockMean", "Mean"));

if nargout == 0 % preview, if run with F5
    page.preview()
end

end
