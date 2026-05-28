classdef dlbsMaskSplit

    methods(Static)

        % Following properties of 'maskInitContext' are available to use:
        %  - BlockHandle 
        %  - MaskObject 
        %  - MaskWorkspace: Use get/set APIs to work with mask workspace.
        function MaskInitialization(maskInitContext)
            b = maskInitContext.BlockHandle;
            m = Simulink.Mask.get(b);
            n_out = str2double(m.getParameter("n_out").Value);
            for i = 1:4
                bname = getfullname(b)+"/Y"+num2str(i);

                if i <= n_out
                    try
                        add_block("simulink/Commonly Used Blocks/Out1",bname,"Name","Y"+num2str(i));
                    catch ME
                        if ~strcmp(ME.identifier, "Simulink:Commands:AddBlockCantAdd")
                            rethrow(ME)
                        end
                    end
                else
                    try
                        delete_block(bname);
                    catch ME
                        if ~strcmp(ME.identifier, "Simulink:Commands:InvSimulinkObjectName")
                            rethrow(ME)
                        end
                    end
                end
            end

        end

        % Following properties of 'maskInitContext' are available to use:
        %  - BlockHandle 
        %  - MaskObject 
        %  - MaskWorkspace: Use get/set APIs to work with mask workspace.
        

        % Use the code browser on the left to add the callbacks.


        function n_out(callbackContext)
            n_out = str2double(callbackContext.ParameterObject.Value);
            b = callbackContext.BlockHandle;
            m = Simulink.Mask.get(b);
            for p = m.Parameters
                if strcmp(p.Name,"n_out")
                    continue
                end

                if str2double(p.Name(2)) > n_out
                    p.Visible = "off";
                else
                    p.Visible = "on";
                end
            end
        end
    end
end