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
#include "mex.h"

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
 * position (latitude and longitude).
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


vector<vector<long long> > run_dijkstra(int num_nodes, double *nodes_ptr, int num_edges, double *edges_ptr,
    int num_src, double *src_ptr, int num_snk, double *snk_ptr)
{
    // maps id numbers to indices
    map<long long, int> id_to_idx;
    map<int, long long> idx_to_id;

    // allocate space for the nodes
    vector<Node> nodes(num_nodes);

    // read in all node information, store current index with id
    for (int i = 0; i < num_nodes; ++i)
    {
        Node node;
        node.id = nodes_ptr[3 * i];
        node.lat = nodes_ptr[3*i + 1];
        node.lon = nodes_ptr[3*i + 2];

        nodes[i] = node;
        id_to_idx[node.id] = i;
        idx_to_id[i] = node.id;
    }

    // allocate space for the adjacency map
    vector<vector<int> > G(num_nodes);

    // read in the edges, map ids to indices and store them in the adjacency list
    for (int i = 0; i < num_edges; ++i)
    {
        long long u_id = edges_ptr[2 * i];
        long long v_id = edges_ptr[2*i + 1];

        int u_idx = id_to_idx[u_id], v_idx = id_to_idx[v_id];

        G[u_idx].push_back(v_idx);
        G[v_idx].push_back(u_idx);
    }

    vector<vector<long long> > shortest_pathes(num_src);

    // vector storing the parent in the induces spanning tree of every node
    vector<int> parent(num_nodes);

    // run dijkstra for every node
    for (int id_src = 0; id_src < num_src; ++id_src)
    {
        // mexPrintf("src_id = %d\n", src_id);

        int src_id = src_ptr[id_src];
        int src_idx = id_to_idx[src_id] - 1;
        // mexPrintf("src_idx = %d\n", src_idx);

        // dist_ptr[id_src * num_src + id_src] = id_src + 1;
        // allocate the heap, together with vectors keeping track of distances
        // and if we visited the current node already
        MaxHeap heap;
        vector<double> distance(num_nodes, INFINITY);
        vector<int> visited(num_nodes);

        // initialize with the current node
        parent[src_idx] = src_idx;
        distance[src_idx] = 0.0;
        State start = make_pair(0.0, src_idx);

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

            // loop through all adjacent nodes
            for (int i = 0; i < G[u.second].size(); ++i)
            {
                int adj_idx = G[u.second][i];

                // continue if this node was visited already
                if (visited[adj_idx])
                    continue;

                // retrieve the node references
                const Node& node1 = nodes[u.second];
                const Node& node2 = nodes[adj_idx];

                // compute their distance and the total distance
                double dist = cos_dist(node1, node2);
                double new_dist = dist + u.first;

                // if the new distance is better than the one stored update it
                // and push it on the heap
                if (new_dist < distance[adj_idx])
                {
                    parent[adj_idx] = u.second;
                    distance[adj_idx] = new_dist;
                    heap.push(make_pair(new_dist, adj_idx));
                }
            }
         }

         deque<int> path;
         int curr_idx = id_to_idx[snk_ptr[id_src]];

         while (true)
         {
            path.push_front(curr_idx);

            if (curr_idx == parent[curr_idx])
                break;

            curr_idx = parent[curr_idx];
         }

        for (int i = 0; i < path.size(); ++i)
        {
            shortest_pathes[id_src].push_back(idx_to_id(path[i]));
        }
    }

    return shortest_pathes;
}


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // if (nrhs < 2 || nrhs > 4)
    // {
    //     mexErrMsgIdAndTxt("MATLAB:dijkstra:nargin",
    //         "DIJKSTRA requires between two and four input arguments.");
    // }

    // if (nlhs < 1 || nlhs > 2)
    // {
    //     mexErrMsgIdAndTxt("MATLAB:dijkstra:nargout",
    //         "DIJKSTRA requires one or two output arguments.");
    // }

    // if (!mxIsNumeric(prhs[0]))
    // {
    //     mexErrMsgIdAndTxt("MATLAB:dijkstra:inputNotNumeric",
    //         "DIJKSTRA requires D to be numeric.");
    // }

    double *nodes_ptr = mxGetPr(prhs[0]);
    double *edges_ptr = mxGetPr(prhs[1]);
    double *src_ptr = mxGetPr(prhs[2]);
    double *snk_ptr = mxGetPr(prhs[3]);

    int num_nodes = mxGetM(prhs[0]);
    int num_edges = mxGetM(prhs[1]);
    int num_src = mxGetM(prhs[2]);
    int num_snk = mxGetM(prhs[3]);

    mexPrintf("%d %d %d %d\n", num_nodes, num_edges, num_src, num_snk);

    vector<vector<long long> > shortest_pathes = run_dijkstra(num_nodes, nodes_ptr, num_edges, edges_ptr,
        num_src, src_ptr, num_snk, snk_ptr);

    int max_path_length = 0;
    for (int i = 0; i < num_src; ++i)
    {
        max_path_length = max(max_path_length, shortest_pathes[i].size());
    }

    plhs[0] = mxCreateDoubleMatrix(num_src, max_path_length, mxREAL);
    double *path_ptr = mxGetPr(plhs[0]);

    for (int i = 0; i < num_src; ++i)
    {
        for (int j = 0; j < shortest_pathes[i].size(); ++j)
        {
            path_ptr[i * max_path_length + j] = shortest_pathes[i][j];
        }
    }
}
