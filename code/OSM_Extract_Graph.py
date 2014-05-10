#!/usr/bin/python
import sys
import xml.etree.ElementTree as ETree

# This data was extracted from the Zurich.osm file.
# The listed speeds are average maxspeeds for the indivudual road types
# rounded to the next multiple of 5.0
max_speeds = {
    'primary_link': 50.0,
    'residential': 30.0,
    'secondary_link': 50.0,
    'primary': 50.0,
    'motorway_link': 75.0,
    'motorway': 90.0,
    'trunk': 70.0,
    'trunk_link': 60.0,
    'unclassified': 40.0,
    'tertiary': 50.0,
    'secondary': 50.0,
    None: 50.0                  # this serves as the default value, we should never have to use this
}

def print_help():
    """
    Prints usage message.
    """
    print 'Usage: {} File.osm [Graph.txt]'.format(sys.argv[0])


def rem_ext(filename):
    """
    Takes a filename as arugment and returns it with the file extension removed.
    Returns the original string if no extension could be found.
    """
    last_dot_idx = filename.rfind('.')
    return filename[:last_dot_idx] if last_dot_idx != -1 else filename


def main():
    """
    Check if enough arguments were provided.
    If not print usage message and exit.
    """
    if len(sys.argv) < 2:
        print_help()
        return

    in_file = sys.argv[1]
    out_file = sys.argv[2] if len(sys.argv) > 2 else '{}_Graph_Speeds.txt'.format(rem_ext(in_file))

    # Parse the input file.
    tree = ETree.parse(in_file)
    root = tree.getroot()

    # Open the output_file for writing.
    f = open(out_file, 'w')

    # Count number of nodes and write it to the file.
    num_nodes = len(root.findall('node'))
    f.write(str(num_nodes) + '\n')

    # For each node print the id together with latitude and longitude.
    for node in root.iter('node'):
        f.write('{} {} {}\n'.format(node.attrib['id'], node.attrib['lat'], node.attrib['lon']))

    # Count the number of node references.
    # Subtract one to account for the fact the we do not print a line after
    # processing the first reference in a way.
    num_nds = 0
    for way in root.iter('way'):
        num_nds = num_nds + max(len(way.findall('nd')) - 1, 0)

    # Write number of edges.
    f.write(str(num_nds) + '\n')

    for way in root.iter('way'):
        highway = None
        maxspeed = None

        for tag in way.iter('tag'):
            if tag.get('k') == 'highway':
                highway = tag.get('v')
            elif tag.get('k') == 'maxspeed':
                maxspeed = float(tag.get('v'))

        if highway is None:
            print "Warning: way {} has no highway tag".format(tag.way('id'))

        if maxspeed is None:
            if highway not in max_speeds:
                highway = None
            maxspeed = max_speeds[highway]

        prev_nd = None

        # For each way print all edges between the referenced nodes and the allowed speed.
        for nd in way.iter('nd'):
            if prev_nd is not None:
                f.write('{} {} {}\n'.format(prev_nd.attrib['ref'], nd.attrib['ref'], maxspeed))

            prev_nd = nd

    # Close the file.
    f.close()


if __name__ == '__main__':
    main()
