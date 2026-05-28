function page = dlbsHelpTop()

page = dlbsHelpPageTemplate("dlbsHelpTop", "Deep Learning Block-Set");

page.addTitle("Deep Learning Block-Set");
page.addParagraph("The Deep Learning Block-Set (DLBS) aims to make deep learning model design, training, and deployment possible directly in Simulink using modular subsystem blocks.");
page.addParagraph("DLBS combines tensor operations, layers, nonlinear activations, loss functions, optimizers, and routing utilities so models can be built graphically and trained in natively in Simnulink.");

page.addTitle("Project Scope");
page.addParagraph("DLBS is intended for educational use, rapid prototyping, and workflows that benefit from Simulink-native model composition and code generation tooling.");
page.addParagraph("For a first hands-on model, start with the peak-classification example in the Getting Started page.");

page.addTitle("Original Contribution");
page.addParagraph("If you use this blockset in your research, please cite the following paper: This entry will be updated, once the original paper is published in IEEE Xplore after the 2026 International Power Electronics Conference (IPEC 2026) held in Nagasaki, Japan");

page.addTitle("License");

page.addParagraph("MIT License");

page.addParagraph("Copyright (c) 2026 Karlsruhe Institute of Technology");

page.addParagraph("Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the ""Software""), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:");

page.addParagraph("The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.");

page.addParagraph("THE SOFTWARE IS PROVIDED ""AS IS"", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.");


page.addTitle("Further Notes");
page.addList(...
	"The documentation were written using AI-tooling using _GPT 5.3-Codex_.",...
	"MathWorks™, MATLAB®, Simulink®, Embedded Coder®, HDL Coder™ and Deep Learning Toolbox™ are registered trademarks of The MathWorks, Inc. ");


if nargout == 0 % preview, if run with F5
	page.preview()
end

end

