function page = dlbsHelpConcepts()

page = dlbsHelpPageTemplate("dlbsHelpConcepts", "Concepts");

page.addTitle("Key Concepts");
page.addParagraph("The Deep Learning Block-Set is designed around several key concepts that define how models are built, executed, and optimized within the Simulink environment:");
page.addList(...
	"The Deep Learning Block-Set implements deep learning building blocks as Simulink subsystems with explicit forward and backward behavior.", ...
	"Complex blocks are built by composing simpler blocks, allowing for modular design and reuse of both forward and backward behavior.", ...
	"The connection of blocks defines the forward data flow of signals for inference and loss calculation.", ...
	"Gradients of the respective signals are propagated in reverse direction by special blocks named ""Gradient Insert"" and ""Gradient Extract"".", ...
	"Learnable parameters are owned by the optimizer blocks.", ...
	"The model is intended to be executed in discrete steps.", ...
	"DLBS blocks operate on multidimensional signals interpreted as tensors, and dimension information can be propagated through connected subsystems.");

page.addTitle("Passing of Gradient");

page.addParagraph("The following image shows the connection of a bias- as well as a square block:");
page.addSubsystemImage("dlbsDocs","outside","outside");
page.addParagraph("In an exploded view, this looks like:");
page.addSubsystemImage("dlbsDocs","inside","inside");

page.addParagraph("This shows a few details of the internal signal flow:");
page.addList(...
	"Every signal input that handles differentiable signals features an ""Insert Gradient"" block at the beginning of the signal path.",...
	"Signal outputs feature ""Extract Gradient"" blocks.",...
	"Between these blocks the signal flow for both the forward and the backward path is defined explicitly.",...
	"Invisible on this layer, each ""Gradient Insert"" block provides a global, unique goto-tag. During model initialization, each ""Gradient Extract"" block searches for the goto-tag of the corresponding ""Gradient Insert"" block and populates its from-tag with the same tag, thus establishing a connection of the backward path between the two blocks.",...
	"In this example, ""Insert Gradient 2"" is connected to ""Extract Gradient 1"", while ""Insert Gradient 1"" and ""Extract Gradient 2"" are connected to blocks upstream or downstream.");

page.addParagraph("Note: earlier material may mention two-way signal connections for gradient passing; this is outdated for the current DLBS implementation.");

page.addTitle("Execution Loop")

page.addParagraph("One execution step consists of the following ordered steps:");
page.addList("Calculation of the forward pass",...
	"Calculation of the loss",...
	"Calculation of the backward pass",...
	"Parameter update by the optimizers");
page.addParagraph("The optimizer blocks feature a ""memory"" block, which stores the updated parameters after each execution step and is needed to break the algebraic loop between the forward and backward path.");

page.addTitle("Propagation of Signal Dimensions");
page.addParagraph("DLBS is designed to use Simulink's propagation of signal dimensions. This means that if dimensions do not match, the model will not run, and it can be difficult to pinpoint the mismatch.");
page.addParagraph("To address this, DLBS provides a special block called ""Specify Dimensions"" that lets the user explicitly define the dimensions of a signal, both for the forward and backward path. An example with dimensionality [3,1,4] is shown below:");

page.addSubsystemImage("dlbsDocs","spec","spec");

if nargout == 0 % preview, if run with F5
	page.preview()
end

end

