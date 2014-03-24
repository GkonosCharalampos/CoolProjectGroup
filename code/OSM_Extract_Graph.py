#!/usr/bin/python
import sys
import xml.etree.ElementTree as ET

def print_help():
    """
    Prints usage message.
    """
    print 'Usage: {} File.osm [Graph.txt]'.format(sys.argv[0])

def main():
    """
    Check if enough arguments were provided.
    If not print usage message and exit.
    """
    if len(sys.argv) < 2:
        print_help()
        return

    """
    Parse the input file.
    """
    tree = ET.parse(sys.argv[1])
    root = tree.getroot()

    """
    Open the output_file for writing.
    """
    out_file = sys.argv[2] if len(sys.argv) > 2 else '{}_Graph.txt'.format(sys.argv[1][:-4])
    f = open(out_file, 'w')

    """
    Count number of nodes and write it to the file.
    """
    num_nodes = len(root.findall('node'))
    f.write(str(num_nodes) + '\n')

    """
    For each node print the id together with latitude and longitude.
    """
    for node in root.iter('node'):
        f.write('{} {} {}\n'.format(node.attrib['id'], node.attrib['lat'], node.attrib['lon']))

    """
    Count the number of node references.
    Subtract one to account for the fact the we do not print a line after
    processing the first reference in a way.
    """
    num_nds = 0
    for way in root.iter('way'):
        num_nds = num_nds + max(len(way.findall('nd')) - 1, 0)

    """
    Write number of edges.
    """
    f.write(str(num_nds) + '\n')

    for way in root.iter('way'):
        prev_nd = None

        """
        For each way print all edges between the referenced nodes.
        """
        for nd in way.iter('nd'):
            if prev_nd is not None:
                f.write('{} {}\n'.format(prev_nd.attrib['ref'], nd.attrib['ref']))

            prev_nd = nd

    """
    Close the file.
    """
    f.close()

if __name__ == '__main__':
    main()
