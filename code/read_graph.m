function [nodes, edges, node_id_to_idx, idx_to_node_id] = read_graph(filename)
	in_file = fopen(filename, 'r');

	num_nodes = fscanf(in_file, '%d\n', 1);
	nodes = fscanf(in_file, '%f %f %f\n', [3, num_nodes]);

	num_edges = fscanf(in_file, '%d\n', 1);
	edges = fscanf(in_file, '%f %f\n', [2, num_edges]);

	fclose(in_file);

	node_id_to_idx = containers.Map('KeyType', 'double', 'ValueType', 'double');
	idx_to_node_id = containers.Map('KeyType', 'double', 'ValueType', 'double');

	for i = 1:num_nodes
		node_id_to_idx(nodes(1, i)) = i;
		idx_to_node_id(i) = nodes(1, i);
	end

	for i = 1:num_nodes
		nodes(1, i) = node_id_to_idx(nodes(1, i));
	end

	for i = 1:num_edges
		edges(1, i) = node_id_to_idx(edges(1, i));
		edges(2, i) = node_id_to_idx(edges(2, i));
	end
end

