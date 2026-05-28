classdef dlbsMaskInsertGradientGF

    methods(Static)

        % Following properties of 'maskInitContext' are available to use:
        %  - BlockHandle
        %  - MaskObject
        %  - MaskWorkspace: Use get/set APIs to work with mask workspace.
        function MaskInitialization(maskInitContext)
            % Rename the goto-tag within this subsystem to an unique string, derived from 
            % the handle of this block. This block works in conjunction with the dlbsGradientFromBlock. 
            % When defining a forward pass with simulink rounting, one would need to also connect the
            % gradient accordingly, to enable back-propagation-ability:
            %
            %           Layer 1 subsystem |               | Layer 2 subsystem
            %                             |   simulink    | 
            % value ----------------------|------>--------|--------------------> value             
            % gradient <------------------|------<--------|------------------ gradient             
            %                             |   routing     | 
            %
            % To hide the gradient-signal (and to also connect it automatically), 
            % the goto/from-system is used:
            %
            %           Layer 1 subsystem |               | Layer 2 subsystem
            %              ----------     |               |    ---------- 
            % value ----> |   dlbs   |    |   simulink    |   |   dlbs   | ----> value
            %             | Gradient | ---|------>--------|-> | Gradient |             
            % gradient <- |   From   |    |   routing     |   |   Goto   | <- gradient
            %              ----------     |               |    ---------- 
            

            % reference to this block
            dlbsInsertGradientBlock = maskInitContext.BlockHandle;

            % Return if this is not an instance
            if strcmp(get_param(dlbsInsertGradientBlock,"BlockType"),"ModelMask")
                return
            end

            % reference to the goto-block
            gotoBlock = find_system(dlbsInsertGradientBlock,'LookUnderMasks','on','FollowLinks','on','Name','Goto');

            % derive a unique string and set the goto-tag accordingly
            tag = sprintf('dlbsGrad_%s',num2hex(dlbsInsertGradientBlock));
            set_param(gotoBlock,'GotoTag', tag);

            % Debug
            % fprintf("set goto-tag of %s to %s\n",getfullname(dlbsInsertGradientBlock), tag);

        end

        % Use the code browser on the left to add the callbacks.

    end
end