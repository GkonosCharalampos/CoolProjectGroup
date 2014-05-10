function paths = a_star(nodes, edges, sources, sinks)
%A_STAR Shortest paths from nodes 'sources' to nodes 'sinks' using A-Star algorithm.
% paths = a_star(nodes, edges, sources, sinks)
%     nodes   = 3 x n node list where the first column specifies node ids
%               and the second and third latitude and longitude.
%     edges   = (2 or 3) x m edge list referencing node ids in the first two columns
%               and giving an optional maximum speed in the third column.
%     sources = 1 x s vector with FROM node indices.
%     sinks   = 1 x s vector with TO node indices.
%     paths   = p x s matrix specifying paths from sources to sinks where p is the
%               longest path length.


    % Input Error Checking ******************************************************
    error(nargchk(4, 4, nargin));
    error(nargchk(0, 1, nargout));

    [dim_nodes, num_nodes] = size(nodes);

    if dim_nodes ~= 3
        error('nodes must contain 3 columns.');
    end

    [dim_edges, num_edges] = size(edges);

    if dim_edges ~= 2 && dim_edges ~= 3
        error('edges must contain 2 or 3 columns.');
    end

    [dim_sources, num_sources] = size(sources);

    if dim_sources ~= 1
        error('sources must be a row vector.');
    end

    [dim_sinks, num_sinks] = size(sinks);

    if dim_sinks ~= 1
        error('sinks must be a row vector.');
    end

    if num_sources ~= num_sinks
        error('sources and sinks must be of the same size.');
    end

    node_ids = nodes(1, :);

    if length(unique(node_ids)) ~= length(node_ids)
        error('The node ids must be unique.');
    end

    if ~all(all(ismember(edges(1:2, :), node_ids)))
        error('edges must reference existing nodes.');
    end

    if ~all(ismember(sources, node_ids))
        error('sources must reference existing nodes.');
    end

    if ~all(ismember(sinks, node_ids))
        error('sinks must reference existing nodes.');
    end

    if dim_edges == 3 && min(edges(3, :)) < 0.0
        error('Travel times must be non-negative.');
    end
    % % End (Input Error Checking) ************************************************

    if dim_edges == 2
        paths = dijkstra_mx(nodes, edges, sources, sinks);
    else
        paths = dijkstra_mx_time(nodes, edges, sources, sinks);
    end
end
