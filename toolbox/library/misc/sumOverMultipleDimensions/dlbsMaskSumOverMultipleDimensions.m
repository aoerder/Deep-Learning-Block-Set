classdef dlbsMaskSumOverMultipleDimensions

    methods(Static)

        % Following properties of 'maskInitContext' are available to use:
        %  - BlockHandle 
        %  - MaskObject 
        %  - MaskWorkspace: Use get/set APIs to work with mask workspace.
        function MaskInitialization(maskInitContext)
            ws = maskInitContext.MaskWorkspace();
            ws.set("length_dims",length(ws.get("dims")));
        end

        % Use the code browser on the left to add the callbacks.

    end
end