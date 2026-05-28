classdef dlbsMaskParametrizedSelector

    methods(Static)

        % Following properties of 'maskInitContext' are available to use:
        %  - BlockHandle
        %  - MaskObject
        %  - MaskWorkspace: Use get/set APIs to work with mask workspace.
        function MaskInitialization(maskInitContext)

            dim = maskInitContext.MaskWorkspace.get("dim");
            allDims = maskInitContext.MaskWorkspace.get("all_dims");
            idx1 = maskInitContext.MaskWorkspace.get("idx1");
            idx2 = maskInitContext.MaskWorkspace.get("idx2");
            
            indexOptionArray = {};
            indexParamArray = {};

            for d = 1:allDims
                if d == dim
                    indexOptionArray{d,1} = 'Index Vector (dialog)';
                    indexParamArray{d,1} = [num2str(idx1), ':', num2str(idx2)];
                else
                    indexOptionArray{d,1} = 'Select all';
                    indexParamArray{d,1} = '';
                end
            end
            numberOfDimensions = num2str(allDims);

            set_param(maskInitContext.BlockHandle, ...
            'IndexOptionArray', indexOptionArray, ...
            'IndexParamArray', indexParamArray, ...
            'NumberOfDimensions', numberOfDimensions);

        end

        % Use the code browser on the left to add the callbacks.

    end
end