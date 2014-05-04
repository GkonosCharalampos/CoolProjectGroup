#!/usr/bin/python
import sys
import xml.etree.ElementTree as ET


def print_help():
    """
    Prints usage message.
    """
    print 'Usage: {} File.osm Simple_Graph.txt [New_Graph.osm]'.format(
        sys.argv[0])


def main():
    """
    Check if enough arguments were provided.
    If not print usage message and exit.
    """
    if len(sys.argv) < 3:
        print_help()
        return

    """
    Parse the input file.
    """
    tree = ET.parse(sys.argv[1])
    root = tree.getroot()

    """
    Allocate space for the allowed nodes
    """
    allowed_nodes = set()
    graph_file = sys.argv[2]

    """
    Parse the graph file and extract the node ids
    """
    with open(graph_file, 'r') as g:
        num_nodes = int(g.readline())

        for x in xrange(num_nodes):
            line = g.readline()
            allowed_nodes.add(int(line.split()[0]))

    """
    Open the output_file for writing.
    """
    out_file = sys.argv[3] if len(sys.argv) > 3 else '{}_Reduced.osm'.format(
        sys.argv[1][:-4])
    f = open(out_file, 'w')

    """
    For each node check if the id is allowed.
    """
    for node in list(root.iter('node')):
        node_id = int(node.attrib['id'])
        if node_id not in allowed_nodes:
            root.remove(node)

    """
    Remove invalid node references
    """
    ways = list(root.iter('way'))
    for way in ways:
        # root.remove(way)
        """
        For each way check if the referenced node is allowed.
        """
        nds = list(way.iter('nd'))
        for nd in nds:
            node_id = int(nd.attrib['ref'])
            if node_id not in allowed_nodes:
                way.remove(nd)

        if len(list(way.iter('nd'))) == 0:
            root.remove(way)

    f.write(ET.tostring(root))

    """
    Close the file.
    """
    f.close()


if __name__ == '__main__':
    main()
