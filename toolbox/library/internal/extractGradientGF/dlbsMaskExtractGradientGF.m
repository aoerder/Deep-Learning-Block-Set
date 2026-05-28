classdef dlbsMaskExtractGradientGF

    methods(Static)

        % Following properties of 'maskInitContext' are available to use:
        %  - BlockHandle
        %  - MaskObject
        %  - MaskWorkspace: Use get/set APIs to work with mask workspace.
        function MaskInitialization(maskInitContext)
            % Rename the goto-tag within this subsystem to an unique string, 
            % derived from the handle of a dlbsGradientGoto-Block, this block is connected to.
            % This block works in conjunction with the dlbsGradientGoto. 
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
            dlbsExtractGradientBlock = maskInitContext.BlockHandle;

            % Return if this is not an instance
            if strcmp(get_param(dlbsExtractGradientBlock,"BlockType"),"ModelMask")
                return
            end

            % reference to the from-block
            fromBlock = find_system(dlbsExtractGradientBlock,'LookUnderMasks','on','FollowLinks','on','Name','From');

            % specify a root and perform a depth-first-search, discovering all connected 
            % dlbsGradientGoto-blocks. 
            valueWithGradPort = find_system(dlbsExtractGradientBlock,'LookUnderMasks','on','FollowLinks','on','Name','valueWithGrad');
            target = dfs(valueWithGradPort);
            
            
            % error out if there are multiple dlbsGradientGoto-blocks
            n_targets = length(target);
            if n_targets > 1
                msg = sprintf("ERROR: Port %s is connected to multiple gradient insertions:", getfullname(valueWithGradPort));
                for n_t = 1:n_targets
                    msg = sprintf("%s\n%s",msg,getfullname(target(n_t)));
                end
                error(msg);
            end

            % derive a unique string from the connected dlbsGradientGoto-block and set 
            % the goto-tag of the from-block accordingly 
            if isscalar(target)
                tag = sprintf('dlbsGrad_%s',num2hex(target));
                set_param(fromBlock,'GotoTag', tag);

                % Debug
                % fprintf("set from-tag of %s to %s\n",getfullname(dlbsExtractGradientBlock), tag);
            else
                %error("Did NOT set from-tag of %s\n",getfullname(dlbsExtractGradientBlock));
            end

            function targets = dfs(port_handle)
                % this function is called recursively

                % list of already discovered dlbsGradientGoto-blocks
                targets = [];

                % list of ports to traverse next
                next_handles = [];

                % Basic procedure: 
                % - If current handle is an outport, list all connections. If the destination is 
                %   no dlbsGradientGoto-block, add it to [targets], otherwise and calls dfs() recursively.
                % - If current handle is an inport, also list all connections. If the destination is 
                %   no dlbsGradientGoto-block, add it to [targets], otherwise and calls dfs() recursively.
                % FIXME: this can be refactored

                switch get_param(port_handle, "BlockType")
                    case 'Outport'
                        parent_subsystem = get_param(port_handle,'Parent');
                        port_number = get_param(port_handle, 'Port');

                        % If the parent subsystem is a variant choice (its parent is a variant
                        % wrapper), Simulink returns empty DstBlock in PortConnectivity for
                        % inactive choices.  Step directly to the wrapper's matching Outport
                        % instead, which has valid external connectivity.
                        grandparent = get_param(parent_subsystem, 'Parent');
                        try
                            gp_is_variant_wrapper = strcmp(get_param(grandparent,'BlockType'),'SubSystem') && ...
                                                    strcmp(get_param(grandparent,'Variant'),'on');
                        catch
                            gp_is_variant_wrapper = false;
                        end

                        if gp_is_variant_wrapper
                            % grandparent is a string path; pass a numeric handle so that
                            % find_system returns numeric handles (not a cell array of paths).
                            gp_handle = get_param(grandparent,'Handle');
                            wrapper_outport = find_system(gp_handle,'MatchFilter',@Simulink.match.legacy.filterOutInactiveVariantSubsystemChoices,...
                                'LookUnderMasks','on','FollowLinks','on','SearchDepth',1,...
                                'BlockType','Outport','Port',port_number);
                            % exclude the wrapper itself (find_system includes the root)
                            wrapper_outport = wrapper_outport(wrapper_outport ~= gp_handle);
                            next_handles = [next_handles, wrapper_outport(:)'];

                        else
                            parent_connections = get_param(parent_subsystem,'PortConnectivity');

                            for parent_connection = parent_connections'
                                if ~isempty(parent_connection.DstBlock) && strcmp(parent_connection.Type,port_number)
                                    destination_blocks = parent_connection.DstBlock;
                                    destination_ports = parent_connection.DstPort;

                                    for k_dst = 1:length(destination_blocks)
                                        destination_block = destination_blocks(k_dst);
                                        destination_port = destination_ports(k_dst);

                                        switch get_param(destination_block, 'BlockType')
                                            case 'Outport'
                                                next_handles(end+1) = destination_block;

                                            case 'SubSystem'
                                                if strcmp(get_param(destination_block,"ReferencedSubsystem"),'dlbsSubsystemInsertGradientGF')
                                                    targets = horzcat(targets,destination_block);
                                                elseif strcmp(get_param(destination_block,'Variant'),'on')
                                                    % Variant subsystem: traverse all variant choices
                                                    variant_choices = find_system(destination_block,'MatchFilter',@Simulink.match.legacy.filterOutInactiveVariantSubsystemChoices,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','BlockType','SubSystem');
                                                    variant_choices = variant_choices(variant_choices ~= destination_block);
                                                    for vc = variant_choices'
                                                        inport_h = find_system(vc,'MatchFilter',@Simulink.match.legacy.filterOutInactiveVariantSubsystemChoices,'LookUnderMasks','on','FollowLinks','on','SearchDepth',1,'BlockType','Inport','Port',num2str(1+destination_port));
                                                        if ~isempty(inport_h)
                                                            next_handles(end+1) = inport_h;
                                                        end
                                                    end
                                                else
                                                    next_handles(end+1) = find_system(destination_block,'MatchFilter',@Simulink.match.legacy.filterOutInactiveVariantSubsystemChoices,'LookUnderMasks','on','FollowLinks','on','SearchDepth',1,'BlockType','Inport','Port',num2str(1+destination_port));
                                                end
                                        end
                                    end
                                    break
                                end
                            end
                        end

                    case 'Inport'
                        line_handle = get_param(port_handle,"LineHandles").Outport;
                        destination_blocks = get_param(line_handle,'DstBlockHandle');
                        destination_ports = get_param(line_handle,'DstPortHandle');

                        for k_dst = 1:length(destination_blocks)
                            destination_block = destination_blocks(k_dst);
                            destination_port_nr = get_param(destination_ports(k_dst),'PortNumber');

                            switch get_param(destination_block, 'BlockType')
                                case 'Outport'
                                    next_handles(end+1) = destination_block;

                                case 'SubSystem'
                                    if strcmp(get_param(destination_block,"ReferencedSubsystem"),'dlbsSubsystemInsertGradientGF')
                                        targets = horzcat(targets,destination_block);
                                    elseif strcmp(get_param(destination_block,'Variant'),'on')
                                        % Variant subsystem: traverse all variant choices
                                        variant_choices = find_system(destination_block,'MatchFilter',@Simulink.match.legacy.filterOutInactiveVariantSubsystemChoices,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','BlockType','SubSystem');
                                        variant_choices = variant_choices(variant_choices ~= destination_block);
                                        for vc = variant_choices'
                                            inport_h = find_system(vc,'MatchFilter',@Simulink.match.legacy.filterOutInactiveVariantSubsystemChoices,'LookUnderMasks','on','FollowLinks','on','SearchDepth',1,'BlockType','Inport','Port',num2str(destination_port_nr));
                                            if ~isempty(inport_h)
                                                next_handles(end+1) = inport_h;
                                            end
                                        end
                                    else
                                        next_handles(end+1) = find_system(destination_block,'MatchFilter',@Simulink.match.legacy.filterOutInactiveVariantSubsystemChoices,'LookUnderMasks','on','FollowLinks','on','SearchDepth',1,'BlockType','Inport','Port',num2str(destination_port_nr));
                                    end
                            end
                        end

                end

                % recursion
                for next_handle = next_handles
                    targets = horzcat(dfs(next_handle),targets);
                end
            end

        end

        % Use the code browser on the left to add the callbacks.

    end
end