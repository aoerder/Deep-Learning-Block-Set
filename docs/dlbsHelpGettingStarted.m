function page = dlbsHelpGettingStarted()

page = dlbsHelpPageTemplate("dlbsHelpGettingStarted", "Getting Started");

page.addTitle("Getting Started");
page.addParagraph("The Deep Learning Block-Set provides a basic example.");

page.addTitle("Example");
page.addParagraph("Start with the peak-classification example model:");
page.addMonospaced("open_system(""dlbsExamplePeakClassification.slx"")");
page.addParagraph("This model uses a simple multilayer perceptron neural network, which is trained to classify data points randomly sampled from the `peaks()` function.");

page.addTitle("First Steps");
page.addList(...
	"Open the model and inspect the data path, network blocks, loss, and optimizer subsystems.", ...
	"Run the model and observe how the loss evolves during simulation.", ...
	"Look under the subsystem masks and explore how tensors and gradients are passed between blocks.", ...
	"Use the Library Reference pages to explore available blocks and parameters.", ...
	"Start training on your own dataset by replacing the data source blocks with your own data loading and preprocessing logic.", ...
	"Start building your own models.");


if nargout == 0 % preview, if run with F5
	page.preview()
end

end

