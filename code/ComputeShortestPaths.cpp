/******************************************************************************
* Includes                                                                    *
******************************************************************************/
#include <vector>
#include <queue>
#include <cmath>
#include <iostream>
#include <map>
#include <functional>
#include <cstring>

/******************************************************************************
* Using directives                                                            *
******************************************************************************/
using std::map;      using std::vector; using std::pair; using std::priority_queue;
using std::ios_base; using std::cin;    using std::cout; using std::endl;
using std::greater;  using std::make_pair;

/******************************************************************************
* Typedefs                                                                    *
******************************************************************************/
typedef vector< vector<int> > Graph;
typedef pair<double, int> State;
typedef priority_queue< State, vector<State>, greater<State> > MaxHeap;


/**
 * Struct representing an OSM node. It consists of its id together with its
 * position (latitude and logitude).
 */
struct Node
{
    long long id;
    double lat, lon;

    Node(long long _id = 0, double _lat = 0.0, double _lon = 0.0) :
        id(_id), lat(_lat), lon(_lon) { }
};


const double radius = 6371.0; // Radius of the earth in km


/**
 * Method to convert degrees to radians
 * @param  deg degrees
 * @return radians
 */
double deg2rad(double deg) {
    return deg * (M_PI / 180.0);
}


/**
 * Computes the haversine distance between two points with given lat and lon.
 * @param  u First Node
 * @param  v Second Node
 * @return Distance
 */
double hav_dist(const Node& u, const Node& v)
{
    double dLat = deg2rad(v.lat - u.lat);
    double dLon = deg2rad(v.lon - u.lon);

    double a = sin(dLat / 2.0) * sin(dLat / 2.0) +
        cos(deg2rad(u.lat)) * cos(deg2rad(v.lat)) *
        sin(dLon / 2.0) * sin(dLon / 2.0);

    double angle = 2 * atan2(sqrt(a), sqrt(1.0 - a));
    return angle * radius;
}


/**
 * Computes the distance between two points with given lat and lon using the law of cosines.
 * @param  u First Node
 * @param  v Second Node
 * @return   Distance
 */
double cos_dist(const Node& u, const Node& v)
{
    double lat1 = deg2rad(u.lat);
    double lat2 = deg2rad(v.lat);

    double dLon = deg2rad(v.lon - u.lon);

    return acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(dLon)) * radius;
}


int main(int argc, char const *argv[])
{
    // disable sync between iostream and cstdio
    ios_base::sync_with_stdio(false);

    // read in number of nodes
    int num_nodes;
    cin >> num_nodes;

    // maps id numbers to indices
    map<long long, int> id2idx;

    // allocate space for the nodes
    Node nodes[num_nodes];

    // read in all node information, store current index with id
    for (int i = 0; i < num_nodes; ++i)
    {
        Node node;
        cin >> node.id >> node.lat >> node.lon;
        nodes[i] = node;
        id2idx[node.id] = i;
    }

    // allocate space for the adjacency map
    vector<int> G[num_nodes];

    // read in number of edges
    int num_edges;
    cin >> num_edges;

    // read in the edges, map ids to indices and store them in the adjacency list
    for (int i = 0; i < num_edges; ++i)
    {
        long long u, v;
        cin >> u >> v;
        int uIdx = id2idx[u], vIdx = id2idx[v];

        G[uIdx].push_back(vIdx);
        G[vIdx].push_back(uIdx);
    }

    // vector storing the parent in the induces spanning tree of every node
    vector<int> parent(num_nodes);

    // run dijkstra for every node
    for (int num_node = 0; num_node < num_nodes; ++num_node)
    {
        // allocate the heap, together with vectors keeping track of distances
        // and if we visited the current node already
        MaxHeap heap;
        vector<double> distance(num_nodes, 1e10);
        vector<int> visited(num_nodes);

        // initialize with the current nodeb
        parent[num_node] = num_node;
        distance[num_node] = 0.0;
        State start = make_pair(0.0, num_node);

        heap.push(start);
        // while the heap is not empty
        while (!heap.empty())
        {
            // pop the first element and check if we visited it already
            State u = heap.top(); heap.pop();

            // if yes continue popping the next element
            if (visited[u.second])
                continue;

            // else mark it as visited
            visited[u.second] = 1;

            // loop through all adjaecnt ndoes
            for (int i = 0; i < G[u.second].size(); ++i)
            {
                int adj = G[u.second][i];

                // continue if this node was visited already
                if (visited[adj])
                    continue;

                // retrieve the node refenrences
                const Node& node1 = nodes[u.second];
                const Node& node2 = nodes[adj];

                // compute their distance and the total distance
                double dist = cos_dist(node1, node2);
                double new_dist = dist + u.first;

                // if the new distance is better than the one stored update it
                // and push it on the heap
                if (new_dist < distance[adj])
                {
                    parent[adj] = u.second;
                    distance[adj] = new_dist;
                    heap.push(make_pair(new_dist, adj));
                }
            }
        }

        // DEBUG: print tree with associated distances
        // for (auto node: parent)
        // {
        //     cout << num_node << " " << node.second << " " << distance[node.second] << "\n";
        // }

        // cout << "\n";
    }

    return 0;
}
