#!/usr/bin/python

import re
import sys


def main():
    """
    This script expects an OpenStreetMap.
    It removes all invalid node references,
    i.e. it just keeps those where the id was defined.
    """

    # Check if file name is given as command line argument,
    # else query user for it
    my_file = raw_input() if len(sys.argv) == 1 else sys.argv[1]

    # initialize set of nodes
    nodes = {}

    # iterate through all lines in the given file
    with open(my_file) as f:
        for line in f:
            if "node id" in line:
                # if "node id" is present in the given line split on
                # quotation mark and store extracted id in the set
                node = int(re.split("['\"]", line)[1])
                nodes[node] = 1

            elif "nd ref" in line:
                # if "nd ref" is present in the given line check
                # if the current id was encountered before, if not skip
                node = int(re.split("['\"]", line)[1])
                if node not in nodes:
                    continue

            print line,


if __name__ == '__main__':
    main()