# MATLAB Spring 2014 – Research Plan (Template)
(text between brackets to be removed)

> * Group Name: Zurich Traffic Group
> * Group participants names: Jan Dörrie, Simone Forte, Charalampos Gkonos, Athina Korfiati  
> * Project Title: Traffic simulation in the city of Zurich

## General Introduction

Traffic is a serious problem with which every city has to deal. In the city of Zurich, traffic is also a problem and the adopted actions aim at a better organisation, which can lead to a better combination of travel safety and efficiency.

## The Model

(Define dependent and independent variables you want to study. Say how you want to measure them.) (Why is your model a good abtraction of the problem you want to study?) (Are you capturing all the relevant aspects of the problem?)


## Fundamental Questions

The goal is to develop an efficient traffic model based on our data. To implement the model in order to visualise the existing traffic situation in the city of Zurich. Then, we want to analyse the impact that a highway tunnel connecting the two sides of the lake would have in the whole area.

## Expected Results

The expected result would be an amelioration of the traffic situation in the city by declining the traffic jams in the main roads. 

## References 

(Add the bibliographic references you intend to use)
(Explain possible extension to the above models)
(Code / Projects Reports of the previous year)

- OpenStreetMap: http://www.openstreetmap.org/
- http://www.ggau.net/html/GG03.html

## Research Methods
Initially we will model the traffic in a very simple approach: 
Using a reduced road network consisting only of Zurich's main roads we assume infinite capacities on the roads 
and will compute the route of every car independently. 
For this we plan to use Shortest Path algorithms, such as Dijkstra and Floyd-Warshall. 
Once we have a working implementation we will investigate the effects of limited capacities 
and also take other cars into account when planning the routes.
Furthermore we will use Cellular Automata to model traffic propagation on given road segments.
Finally we will introduce the planned tunnel to the road network and measure its effect on the overall traffic situation.


## Other

We will make use of OpenStreetMap which provides us with the complete road network of Zurich.
It includes the type of the road (motorway, trunk, primary, etc.) and coordinates of points a long the streets.
This enables us to realistically model traffic including direction and speed of every car.
