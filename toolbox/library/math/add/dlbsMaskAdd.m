classdef dlbsMaskAdd

    methods(Static)

        % Use the code browser on the left to add the callbacks.


        function broadcast(callbackContext)
            m = Simulink.Mask.get(callbackContext.BlockHandle);
            dims1_param = m.getParameter("dims1");
            dims2_param = m.getParameter("dims2");
            broadcast_state = callbackContext.ParameterObject.Value;
            dims1_param.Visible = broadcast_state;
            dims2_param.Visible = broadcast_state;

            if strcmp(broadcast_state,"on")
                set_param(callbackContext.BlockHandle,"LabelModeActiveChoice","broadcast")
            else
                set_param(callbackContext.BlockHandle,"LabelModeActiveChoice","no broadcast")
            end
        end

    end
end